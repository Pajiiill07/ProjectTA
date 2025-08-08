from pydantic import BaseModel
from datetime import date
from datetime import datetime
from enum import Enum
from typing import Optional
from app.schemas.user_sch import UserOut

class JenjangEnum(str, Enum):
    slta = "SLTA"
    d3 = "D3"
    d4s1 = "D4/S1"
    s2 = "S2"
    s3 = "S3"

class RiwayatPenBase(BaseModel):
    jenjang: JenjangEnum
    instansi: str
    jurusan: str
    tahun_mulai: date
    tahun_selesai: Optional[date]

class RiwayatPenCreate(RiwayatPenBase):
    user_id: Optional[int] = None

class RiwayatPenUpdate(RiwayatPenBase):
    pass

class RiwayatPenOut(RiwayatPenBase):
    riwayat_id: int
    user_id: int
    create_at: datetime
    update_at: datetime
    user: Optional[UserOut]

    model_config={
        "from_attributes": True
    }