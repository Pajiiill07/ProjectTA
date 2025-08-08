from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.mysql import get_db
from app.models import dataset_labeled as models
from app.schemas import dataset_sch as schemas
from typing import List
import os
import pandas as pd

router = APIRouter()

@router.get("/", response_model=List[schemas.DatasetOut])
def get_dataset(
    db: Session = Depends(get_db)
):
    return db.query(models.DatasetLabeled).all()

@router.post("/import-csv", response_model=dict)
def import_csv_to_db(db: Session = Depends(get_db)):
    file_path = "app/data/dataset_final.csv"

    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="File CSV tidak ditemukan")

    df = pd.read_csv(file_path)
    df = df.where(pd.notnull(df), None)

    for _, row in df.iterrows():
        dataset = models.DatasetLabeled(
            judul=row['judul'],
            perusahaan=row['perusahaan'],
            deskripsi=row['deskripsi'],
            label=row['label']
        )
        db.add(dataset)

    db.commit()
    return {"message": "Data dari CSV berhasil diimpor ke database"}