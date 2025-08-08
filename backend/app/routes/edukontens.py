from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.mysql import get_db
from app.models import edu_konten as models
from app.schemas import edukonten_sch as schemas
from typing import List
from app.models.user import User
from app.utils.auth_set import admin_required
from sqlalchemy.orm import joinedload
from app.utils.auth_set import get_current_user

router = APIRouter()

# get list edu konten
@router.get("/", response_model=List[schemas.EduKonOut])
def get_konten(db:Session=Depends(get_db)):
    list_konten = db.query(models.EduKonten).all()
    return list_konten

# get konten by id
@router.get("/{konten_id}", response_model=schemas.EduKonOut)
def get_konten_by_id(
    konten_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    data_konten = (
        db.query(models.EduKonten)
        .filter(models.EduKonten.konten_id == konten_id)
        .first()
    )
    
    if not data_konten:
        raise HTTPException(status_code=404, detail="Konten tidak ditemukan")

    return data_konten

# post/ create edu konten by admin
@router.post("/", response_model=schemas.EduKonOut)
def create_konten(
    edu_konten: schemas.EduKonCreate, 
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    data_dict = edu_konten.dict()

    new_data = models.EduKonten(**data_dict)
    db.add(new_data)
    db.commit()
    db.refresh(new_data)
    return new_data


# put/ edit edu konten
@router.put("/{konten_id}", response_model=schemas.EduKonOut)
def update_konten(
    konten_id: int, 
    edu_konten: schemas.EduKonUpdate, 
    db:Session=Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_konten = db.query(models.EduKonten).filter(models.EduKonten.konten_id == konten_id).first()

    if not db_konten:
        raise HTTPException(status_code=400, detail="Konten edukasi tidak ditemukan")
    
    update_konten = edu_konten.dict(exclude_unset=True)

    for key, value in update_konten.items():
        setattr(db_konten, key, value)
    
    db.commit()
    db.refresh(db_konten)
    return db_konten

# delete edu konten
@router.delete("/{konten_id}", response_model=schemas.EduKonOut)
def delete_konten(
    konten_id:int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_konten = db.query(models.EduKonten).filter(models.EduKonten.konten_id == konten_id).first()

    if not db_konten:
        raise HTTPException(status_code=400, detail="Konten edukasi tidak ditemukan")
    
    db.delete(db_konten)
    db.commit()
    return db_konten