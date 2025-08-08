from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.mysql import get_db
from app.models import riwayat_pendidikan as models
from app.schemas import riwayatpen_sch as schemas
from app.models.user import User
from app.utils.auth_set import get_current_user
from typing import List
from sqlalchemy.orm import joinedload
from app.utils.auth_set import admin_required

router = APIRouter()

# get list riwayat pendidikan
@router.get("/", response_model=List[schemas.RiwayatPenOut])
def get_riwayat(
    db:Session=Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return db.query(models.Riwayat_Pendidikan).options(joinedload(models.Riwayat_Pendidikan.user)).all()

# get riwayat pendidikan by id
@router.get("/{riwayat_id}", response_model=schemas.RiwayatPenOut)
def get_riwayat_pen_by_id(
    riwayat_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    data_user = (
        db.query(models.Riwayat_Pendidikan)
        .options(joinedload(models.Riwayat_Pendidikan.user))
        .filter(models.Riwayat_Pendidikan.riwayat_id == riwayat_id)
        .first()
    )
    
    if not data_user:
        raise HTTPException(status_code=404, detail="Data user tidak ditemukan")

    return data_user

# get my riwayat pendidikan  (current user)
@router.get("/me/all", response_model=List[schemas.RiwayatPenOut])
def get_my_riwayat(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    my_riwayat = db.query(models.Riwayat_Pendidikan).filter(
        models.Riwayat_Pendidikan.user_id == current_user.user_id
    ).all()

    if not my_riwayat:
        raise HTTPException(status_code=404, detail="Data riwayat pendidikan tidak ditemukan")
    
    return my_riwayat

# post/ create riwayat pendidikan dengan check role
@router.post("/", response_model=schemas.RiwayatPenOut)
def create_data(
    riwayat: schemas.RiwayatPenCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role == "admin":
        if not riwayat.user_id:
            raise HTTPException(status_code=400, detail="user_id is required for admin")
        target_user_id = riwayat.user_id

    else:
        if riwayat.user_id is not None:
            raise HTTPException(status_code=403, detail="You are not allowed to set user_id")
        target_user_id = current_user.user_id

    new_data = models.Riwayat_Pendidikan(
        **riwayat.dict(exclude={"user_id"}),
        user_id=target_user_id
    )

    db.add(new_data)
    db.commit()
    db.refresh(new_data)
    return new_data

# put/ update my riwayat
@router.put("/me/{riwayat_id}", response_model=schemas.RiwayatPenOut)
def update_my_riwayat(
    riwayat: schemas.RiwayatPenUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    db_data = db.query(models.Riwayat_Pendidikan).filter(models.Riwayat_Pendidikan.user_id == current_user.user_id).first()

    if not db_data:
        raise HTTPException(status_code=404, detail="Data riwayat pendidikan untuk user ini tidak ditemukan")

    update_data = riwayat.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_data, key, value)

    db.commit()
    db.refresh(db_data)
    return db_data

# put/ edit riwayat pendidikan by admin
@router.put("/{riwayat_id}", response_model=schemas.RiwayatPenOut)
def update_riwayat(
    riwayat_id: int, 
    riwayat_pendidikan: schemas.RiwayatPenUpdate, 
    db:Session=Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_riwayat = db.query(models.Riwayat_Pendidikan).filter(models.Riwayat_Pendidikan.riwayat_id == riwayat_id).first()

    if not db_riwayat:
        raise HTTPException(status_code=400, detail="Data RiwayatPen tidak ditemukan")
    
    update_riwayat = riwayat_pendidikan.dict(exclude_unset=True)

    for key, value in update_riwayat.items():
        setattr(db_riwayat, key, value)

    db.commit()
    db.refresh(db_riwayat)
    return db_riwayat

# delete riwayat pendidikan
@router.delete("/{riwayat_id}", response_model=schemas.RiwayatPenOut)
def delete_riwayat(
    riwayat_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_riwayat = db.query(models.Riwayat_Pendidikan)\
        .options(joinedload(models.Riwayat_Pendidikan.user))\
        .filter(models.Riwayat_Pendidikan.riwayat_id == riwayat_id)\
        .first()

    if not db_riwayat:
        raise HTTPException(status_code=400, detail="Data RiwayatPen tidak ditemukan")

    # Salin data sebelum dihapus
    result = schemas.RiwayatPenOut.model_validate(db_riwayat)

    db.delete(db_riwayat)
    db.commit()
    return result