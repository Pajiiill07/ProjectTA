from pydantic import BaseModel
from datetime import datetime
from enum import Enum
from typing import Optional
from app.schemas.user_sch import UserOut

class KategoriEnum(str, Enum):
    soft_skill = "Soft Skill"
    hard_skil = "Hard Skill"

class KeahlianBase(BaseModel):
    nama_skill: str
    kategori: KategoriEnum

class KeahlianCreate(KeahlianBase):
    user_id: Optional[int] = None

class KeahlianUpdate(KeahlianBase):
    pass

class KeahlianOut(KeahlianBase):
    keahlian_id: int
    user_id: int
    create_at: datetime
    update_at: datetime
    user: Optional[UserOut]

    model_config = {
        "from_attributes": True
    }