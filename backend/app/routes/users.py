from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Form
from sqlalchemy.orm import Session
from app.database.mysql import get_db
from app.models import user as models
from app.schemas import user_sch as schemas
from app.utils.hash_pw import hash_pw
from typing import List
from app.models.user import User
from app.utils.auth_set import get_current_user
from app.utils.auth_set import admin_required
from app.utils.role_enum import UserRoleEnum
import os
import uuid

router = APIRouter()

# get list users
@router.get("/", response_model=List[schemas.UserOut])
def get_user(db:Session=Depends(get_db)):
    list_user = db.query(models.User).all()
    return list_user

# get user by id
@router.get("/{user_id}", response_model=schemas.UserOut)
def get_user_by_id(
    user_id: int, 
    db: Session = Depends(get_db)
):
    db_user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User tidak ditemukan")
    return db_user

# get current user
@router.get("/me/profile")
def get_logged_in_user(current_user: User = Depends(get_current_user)):
    return {
        "user_id": current_user.user_id,
        "username": current_user.username,
        "email": current_user.email,
        "role": current_user.role,
        "photo_url": current_user.photo_url
    }

# create/post user by admin
@router.post("/", response_model=schemas.UserOut)
def create_user(
    username: str = Form(...),
    email: str = Form(...),
    password: str = Form(...),
    role: UserRoleEnum = Form(...),
    photo: UploadFile = File(None),  # Opsional
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    # Validasi duplikasi email
    db_user = db.query(models.User).filter(models.User.email == email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email sudah digunakan!")

    hashed_pw = hash_pw(password)

    photo_url = "default.jpg"

    if photo:
        UPLOAD_DIR = "app/static/upload" 
        os.makedirs(UPLOAD_DIR, exist_ok=True)

        ext = os.path.splitext(photo.filename)[1]
        filename = f"{uuid.uuid4()}{ext}"
        file_location = os.path.join(UPLOAD_DIR, filename)

        with open(file_location, "wb") as f:
            f.write(photo.file.read())

        photo_url = f"/static/upload/{filename}"


    new_user = models.User(
        username=username,
        email=email,
        password=hashed_pw,
        role=role,
        photo_url=photo_url
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user 

# update/put my user data
from fastapi import Form, File, UploadFile

@router.put("/me", response_model=schemas.UserOut)
async def update_own_profile(
    username: str = Form(...),
    email: str = Form(...),
    password: str = Form(None),
    photo: UploadFile = File(None),
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    db_user = db.query(models.User).filter(models.User.user_id == current_user.user_id).first()

    if not db_user:
        raise HTTPException(status_code=404, detail="User not found!")

    db_user.username = username
    db_user.email = email
    if password:
        from app.utils.hash_pw import hash_pw
        db_user.password = hash_pw(password)

    if photo:
        UPLOAD_DIR = "app/static/upload" 
        os.makedirs(UPLOAD_DIR, exist_ok=True)

        ext = os.path.splitext(photo.filename)[1]
        filename = f"{uuid.uuid4()}{ext}"
        file_location = os.path.join(UPLOAD_DIR, filename)

        with open(file_location, "wb") as f:
            f.write(photo.file.read())

        photo_url = f"/static/upload/{filename}"
        db_user.photo_url = photo_url

    db.commit()
    db.refresh(db_user)

    return db_user


# update/put user by admin
@router.put("/{user_id}", response_model=schemas.UserOut)
def update_user_by_admin(
    user_id: int,
    username: str = Form(...),
    email: str = Form(...),
    password: str = Form(""),
    role: UserRoleEnum = Form(...),
    photo: UploadFile = File(None),
    db: Session = Depends(get_db),
    current_user: models.User = Depends(admin_required)
):
    db_user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found!")

    db_user.username = username
    db_user.email = email
    if password:
        db_user.password = hash_pw(password)
    db_user.role = role

    if photo:
        UPLOAD_DIR = "app/static/upload"
        os.makedirs(UPLOAD_DIR, exist_ok=True)

        ext = os.path.splitext(photo.filename)[1]
        filename = f"{uuid.uuid4()}{ext}"
        file_location = os.path.join(UPLOAD_DIR, filename)

        with open(file_location, "wb") as f:
            f.write(photo.file.read())

        db_user.photo_url = f"/static/upload/{filename}"

    db.commit()
    db.refresh(db_user)
    return db_user

# delete user
@router.delete("/{user_id}", response_model=schemas.UserOut)
def delete_user(
    user_id:int, 
    db: Session = Depends(get_db), 
    current_user: User = Depends(admin_required)
):
    db_user = db.query(models.User).filter(models.User.user_id == user_id).first()

    if not db_user:
        raise HTTPException(status_code=400, detail="User tidak ditemukan")
    
    db.delete(db_user)
    db.commit()
    return db_user