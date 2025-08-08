from pydantic import BaseModel
from datetime import datetime
from datetime import date
from enum import Enum

class LabelEnum(str, Enum):
    asli = "asli"
    palsu = "palsu"

class DatasetBase(BaseModel):
    judul: str
    perusahaan: str
    deskripsi: str
    label: LabelEnum

class DatasetCreate(DatasetBase):
    pass

class DatasetUpdate(DatasetBase):
    pass

class DatasetOut(DatasetBase):
    dataset_id: int
    create_at: datetime
    update_at: datetime

    model_config={
        "from_attributes": True
    }