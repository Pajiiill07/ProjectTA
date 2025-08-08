from pydantic import BaseModel, EmailStr
from app.utils.role_enum import UserRoleEnum
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    username: str
    email: EmailStr

class UserCreate(UserBase):
    password: str
    
class UserUpdate(UserBase):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None
    role: Optional[UserRoleEnum] = None
    photo_url: Optional[str] = None

class UserOut(UserBase):
    user_id: int
    role : UserRoleEnum
    create_at: datetime
    update_at: datetime
    photo_url: Optional[str] = None

    model_config = {
        "from_attributes": True
    }