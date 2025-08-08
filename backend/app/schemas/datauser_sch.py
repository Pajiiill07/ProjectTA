from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from app.schemas.user_sch import UserOut

class UserDataBase(BaseModel):
    nama_lengkap: str
    no_telp: str
    linkedin: str
    alamat: str
    summary: str

class UserDataCreate(UserDataBase):
    user_id: Optional[int] = None

class UserDataUpdate(UserDataBase):
    pass

class UserDataOut(UserDataBase):
    data_id: int
    user_id: int
    create_at: datetime
    update_at: datetime
    user: Optional[UserOut]

    model_config = {
        "from_attributes": True
    }
