from pydantic import BaseModel
from datetime import date
from datetime import datetime
from typing import Optional
from app.schemas.user_sch import UserOut

class PengalamanBase(BaseModel):
    judul: str
    instansi: str
    tanggal_kegiatan: date
    keterangan: str

class PengalamanCreate(PengalamanBase):
    user_id: Optional[int] = None

class PengalamanUpdate(PengalamanBase):
    pass

class PengalamanOut(PengalamanBase):
    pengalaman_id: int
    user_id: int
    create_at: datetime
    update_at: datetime
    user: Optional[UserOut]

    model_config = {
        "from_attributes": True
    }