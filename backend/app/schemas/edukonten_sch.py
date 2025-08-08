from pydantic import BaseModel
from datetime import datetime
from datetime import date
from enum import Enum
from typing import Optional

class KategoriEnum(str, Enum):
    artikel = "Artikel"
    tips = "Tips"

class EduKonBase(BaseModel):
    judul: str
    isi: str
    kategori: KategoriEnum
    sumber: str

class EduKonCreate(EduKonBase):
    pass 

class EduKonUpdate(EduKonBase):
    pass

class EduKonOut(EduKonBase):
    konten_id: int
    create_at: datetime
    update_at: datetime

    model_config={
        "from_attributes": True
    }