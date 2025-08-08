from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordRequestForm
from app.database.mysql import get_db
from app.services.auth_service import authenticate_user, create_token_for_user
from app.schemas.auth_sch import Token
from app.models.user import User
from app.utils.auth_set import get_current_user
from fastapi.responses import JSONResponse
from app.models import user as models
from app.schemas import user_sch as schemas
from app.utils.hash_pw import hash_pw
from app.utils.role_enum import UserRoleEnum


router = APIRouter()

# login user
@router.post("/login", response_model=Token)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email atau password salah",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    token = create_token_for_user(user)

    return {"access_token": token, "token_type": "bearer"}

# register user - role "user"
@router.post("/register", response_model=schemas.UserOut)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    # Cek apakah email sudah digunakan
    existing_user = db.query(models.User).filter(models.User.email == user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email sudah terdaftar")

    hashed_password = hash_pw(user.password)

    db_user = models.User(
        username=user.username,
        email=user.email,
        password=hashed_password,
        role=UserRoleEnum.user
    )

    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# logout user
@router.post("/logout")
def logout(current_user: User = Depends(get_current_user)):
    # JWT tidak bisa "dibatalkan" server-side tanpa blacklist
    return JSONResponse(
        status_code=200,
        content={"message": f"User {current_user.username} logged out. Silakan hapus token di client."}
    )