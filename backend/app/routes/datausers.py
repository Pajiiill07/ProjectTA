from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.mysql import get_db
from app.models import data_user as models
from app.schemas import datauser_sch as schemas
from app.models.user import User
from app.utils.auth_set import get_current_user
from typing import List
from sqlalchemy.orm import joinedload
from typing import Optional
from app.utils.auth_set import admin_required

router = APIRouter()

# get list data user
@router.get("/", response_model=List[schemas.UserDataOut])
def get_datauser(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return db.query(models.DataUser).options(joinedload(models.DataUser.user)).all()

# get data user by id
@router.get("/{data_id}", response_model=schemas.UserDataOut)
def get_data_user_by_id(
    data_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    data_user = (
        db.query(models.DataUser)
        .options(joinedload(models.DataUser.user))
        .filter(models.DataUser.data_id == data_id)
        .first()
    )
    
    if not data_user:
        raise HTTPException(status_code=404, detail="Data user tidak ditemukan")

    return data_user

# get data user me (current user login)
@router.get("/me/data", response_model=schemas.UserDataOut)
def get_my_data(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    my_data = db.query(models.DataUser).filter(models.DataUser.user_id == current_user.user_id).first()

    if not my_data:
        raise HTTPException(status_code=404, detail="Data tidak ditemukan")

    return my_data

# post/ create data user dengan check role
@router.post("/", response_model=schemas.UserDataOut)
def create_data(
    data_user: schemas.UserDataCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role == "admin":
        if not data_user.user_id:
            raise HTTPException(status_code=400, detail="user_id is required for admin")
        target_user_id = data_user.user_id

    else:
        if data_user.user_id is not None:
            raise HTTPException(status_code=403, detail="You are not allowed to set user_id")
        target_user_id = current_user.user_id

    new_data = models.DataUser(
        **data_user.dict(exclude={"user_id"}), 
        user_id=target_user_id
    )

    db.add(new_data)
    db.commit()
    db.refresh(new_data)
    return new_data

# put/ update my data user
@router.put("/me", response_model=schemas.UserDataOut)
def update_my_data(
    data_user: schemas.UserDataUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    db_data = db.query(models.DataUser).filter(models.DataUser.user_id == current_user.user_id).first()

    if not db_data:
        raise HTTPException(status_code=404, detail="Data untuk user ini tidak ditemukan")

    update_data = data_user.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_data, key, value)

    db.commit()
    db.refresh(db_data)
    return db_data

# put/ update data user by admin
@router.put("/{data_id}", response_model=schemas.UserDataOut)
def update_data(
    data_id: int,
    data_user: schemas.UserDataUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_data = db.query(models.DataUser).filter(models.DataUser.data_id == data_id).first()

    if not db_data:
        raise HTTPException(status_code=400, detail="Data User tidak ditemukan")
    
    update_data = data_user.dict(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_data, key, value)

    db.commit()
    db.refresh(db_data)
    return db_data

# delete data user
@router.delete("/{data_id}", response_model=schemas.UserDataOut)
def delete_data(
    data_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_data = (
        db.query(models.DataUser)
        .options(joinedload(models.DataUser.user))  # ← preload relasi
        .filter(models.DataUser.data_id == data_id)
        .first()
    )

    if not db_data:
        raise HTTPException(status_code=400, detail="Data User tidak ditemukan")

    response_data = schemas.UserDataOut.from_orm(db_data)

    db.delete(db_data)
    db.commit()

    return response_data
