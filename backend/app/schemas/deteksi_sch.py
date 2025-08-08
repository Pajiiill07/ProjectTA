from pydantic import BaseModel
from datetime import datetime, date
from enum import Enum


class HasilEnum(str, Enum):
    asli = "asli"
    palsu = "palsu"

class DeteksiBase(BaseModel):
    judul: str
    perusahaan: str
    deskripsi: str

class DeteksiCreate(DeteksiBase):
    judul: str
    perusahaan: str
    deskripsi: str

class DeteksiOut(DeteksiBase):
    deteksi_id: int
    user_id: int
    hasil: HasilEnum
    detail: str
    tanggal_deteksi: date
    create_at: datetime
    update_at: datetime

    model_config = {
        "from_attributes": True
    }
