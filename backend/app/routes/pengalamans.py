from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.mysql import get_db
from app.models import pengalaman as models
from app.schemas import pengalaman_sch as schemas
from app.models.user import User
from app.utils.auth_set import get_current_user
from typing import List
from sqlalchemy.orm import joinedload
from app.utils.auth_set import admin_required

router = APIRouter()

# get list pengalaman
@router.get("/", response_model=List[schemas.PengalamanOut])
def get_pengalaman(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return db.query(models.Pengalaman).options(joinedload(models.Pengalaman.user)).all()

# get pengalaman by id
@router.get("/{pengalaman_id}", response_model=schemas.PengalamanOut)
def get_pengalaman_by_id(
    pengalaman_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    data_user = (
        db.query(models.Pengalaman)
        .options(joinedload(models.Pengalaman.user))
        .filter(models.Pengalaman.pengalaman_id == pengalaman_id)
        .first()
    )
    
    if not data_user:
        raise HTTPException(status_code=404, detail="Data user tidak ditemukan")

    return data_user

# get pengalaman me (current user)
@router.get("/me/all", response_model=List[schemas.PengalamanOut])
def get_my_pengalaman(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    my_pengalaman = db.query(models.Pengalaman).filter(
        models.Pengalaman.user_id == current_user.user_id
    ).all()

    if not my_pengalaman:
        raise HTTPException(status_code=404, detail="Data pengalaman tidak ditemukan")
    
    return my_pengalaman

# post/ create pengalaman dengan check role
@router.post("/", response_model=schemas.PengalamanOut)
def create_data(
    pengalaman: schemas.PengalamanCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role == "admin":
        if not pengalaman.user_id:
            raise HTTPException(status_code=400, detail="user_id is required for admin")
        target_user_id = pengalaman.user_id

    else:
        if pengalaman.user_id is not None:
            raise HTTPException(status_code=403, detail="You are not allowed to set user_id")
        target_user_id = current_user.user_id

    new_data = models.Pengalaman(
        **pengalaman.dict(exclude={"user_id"}),
        user_id=target_user_id
    )

    db.add(new_data)
    db.commit()
    db.refresh(new_data)
    return new_data

# put/ update my pengalaman
@router.put("/me/{pengalaman_id}", response_model=schemas.PengalamanOut)
def update_my_pengalaman(
    pengalaman: schemas.PengalamanUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    db_data = db.query(models.Pengalaman).filter(models.Pengalaman.user_id == current_user.user_id).first()

    if not db_data:
        raise HTTPException(status_code=404, detail="Data pengalaman untuk user ini tidak ditemukan")

    update_data = pengalaman.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_data, key, value)

    db.commit()
    db.refresh(db_data)
    return db_data

# put/ edit pengalaman by admin
@router.put("/{pengalaman_id}", response_model=schemas.PengalamanOut)
def update_pengalaman(
    pengalaman_id: int, 
    pengalaman: schemas.PengalamanUpdate, 
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_pengalaman = db.query(models.Pengalaman).filter(models.Pengalaman.pengalaman_id == pengalaman_id).first()

    if not db_pengalaman:
        raise HTTPException(status_code=400, detail="Data Pengalaman tidak ditemukan")
    
    update_pengalaman = pengalaman.dict(exclude_unset=True)

    for key, value in update_pengalaman.items():
        setattr(db_pengalaman, key, value)

    db.commit()
    db.refresh(db_pengalaman)
    return db_pengalaman

# delete pengalaman
@router.delete("/{pengalaman_id}", response_model=schemas.PengalamanOut)
def delete_pengalaman(
    pengalaman_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_pengalaman = db.query(models.Pengalaman)\
        .options(joinedload(models.Pengalaman.user))\
        .filter(models.Pengalaman.pengalaman_id == pengalaman_id)\
        .first()

    if not db_pengalaman:
        raise HTTPException(status_code=400, detail="Data Pengalaman tidak ditemukan")

    # Salin data sebelum dihapus
    result = schemas.PengalamanOut.model_validate(db_pengalaman)

    db.delete(db_pengalaman)
    db.commit()
    return result