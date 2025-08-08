from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.mysql import get_db
from app.models import keahlian as models
from app.schemas import keahlian_sch as schemas
from app.models.user import User
from app.utils.auth_set import get_current_user
from typing import List
from sqlalchemy.orm import joinedload
from app.utils.auth_set import admin_required

router = APIRouter()

# get list keahlian
@router.get("/", response_model=List[schemas.KeahlianOut])
def get_keahlian(
    db:Session=Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return db.query(models.Keahlian).options(joinedload(models.Keahlian.user)).all()

# get keahlian by id
@router.get("/{keahlian_id}", response_model=schemas.KeahlianOut)
def get_keahlian_by_id(
    keahlian_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    data_keahlian = (
        db.query(models.Keahlian)
        .options(joinedload(models.Keahlian.user))
        .filter(models.Keahlian.keahlian_id == keahlian_id)
        .first()
    )
    
    if not data_keahlian:
        raise HTTPException(status_code=404, detail="Data tidak ditemukan")

    return data_keahlian

# get my keahlian  (current user)
@router.get("/me/all", response_model=List[schemas.KeahlianOut])
def get_my_keahlian(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    my_keahlian = db.query(models.Keahlian).filter(
        models.Keahlian.user_id == current_user.user_id
    ).all()

    if not my_keahlian:
        raise HTTPException(status_code=404, detail="Data tidak ditemukan")
    
    return my_keahlian

# post/ create keahlian dengan check role
@router.post("/", response_model=schemas.KeahlianOut)
def create_data(
    keahlian: schemas.KeahlianCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role == "admin":
        if not keahlian.user_id:
            raise HTTPException(status_code=400, detail="user_id is required for admin")
        target_user_id = keahlian.user_id

    else:
        if keahlian.user_id is not None:
            raise HTTPException(status_code=403, detail="You are not allowed to set user_id")
        target_user_id = current_user.user_id

    new_data = models.Keahlian(
        **keahlian.dict(exclude={"user_id"}),
        user_id=target_user_id
    )

    db.add(new_data)
    db.commit()
    db.refresh(new_data)
    return new_data

# put/ update my keahlian
@router.put("/me/{keahlian_id}", response_model=schemas.KeahlianOut)
def update_my_keahlian(
    keahlian: schemas.KeahlianUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    db_data = db.query(models.Keahlian).filter(models.Keahlian.user_id == current_user.user_id).first()

    if not db_data:
        raise HTTPException(status_code=404, detail="Data keahlian untuk user ini tidak ditemukan")

    update_data = keahlian.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_data, key, value)

    db.commit()
    db.refresh(db_data)
    return db_data

# put/ edit keahlian by admin
@router.put("/{keahlian_id}", response_model=schemas.KeahlianOut)
def update_keahlian(
    keahlian_id: int, 
    keahlian: schemas.KeahlianUpdate, 
    db:Session=Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_keahlian = db.query(models.Keahlian).filter(models.Keahlian.keahlian_id == keahlian_id).first()

    if not db_keahlian:
        raise HTTPException(status_code=400, detail="Data Keahlian tidak ditemukan")
    
    update_keahlian = keahlian.dict(exclude_unset=True)

    for key, value in update_keahlian.items():
        setattr(db_keahlian, key, value)

    db.commit()
    db.refresh(db_keahlian)
    return db_keahlian

# delete keahlian
@router.delete("/{keahlian_id}", response_model=schemas.KeahlianOut)
def delete_keahlian(
    keahlian_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_keahlian = db.query(models.Keahlian)\
        .options(joinedload(models.Keahlian.user))\
        .filter(models.Keahlian.keahlian_id == keahlian_id)\
        .first()

    if not db_keahlian:
        raise HTTPException(status_code=400, detail="Data keahlian tidak ditemukan")

    # Salin data sebelum dihapus
    result = schemas.KeahlianOut.model_validate(db_keahlian)

    db.delete(db_keahlian)
    db.commit()
    return result