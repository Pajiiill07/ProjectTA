from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.mysql import get_db
from app.models import deteksi_lowongan as models
from app.schemas import deteksi_sch as schemas
from typing import List
from app.models.user import User
from app.utils.auth_set import get_current_user
from app.services.preprocessing import preprocess_text
from app.services.rule_based import rule_based
from app.services.openai import get_openai_assessment, combine_assessments
from datetime import date, datetime
import json
from app.utils.auth_set import admin_required
from sqlalchemy.orm import joinedload
import os

router = APIRouter()

# get list deteksi lowongan
@router.get("/", response_model=List[schemas.DeteksiOut])
def get_datadeteksi(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return db.query(models.DeteksiLowongan).all()

# get deteksi lowongan by id
@router.get("/{deteksi_id}", response_model=schemas.DeteksiOut)
def get_deteksi_by_id(
    deteksi_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    deteksi = db.query(models.DeteksiLowongan).filter(models.DeteksiLowongan.deteksi_id == deteksi_id).first()
    
    if not deteksi:
        raise HTTPException(status_code=404, detail="Data deteksi tidak ditemukan")
    
    return deteksi

# get my deteksi lowongan (current user)
@router.get("/me/all", response_model=List[schemas.DeteksiOut])
def get_my_deteksi(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    my_deteksi = db.query(models.DeteksiLowongan).filter(
        models.DeteksiLowongan.user_id == current_user.user_id
    ).all()

    if not my_deteksi:
        raise HTTPException(status_code=404, detail="Data deteksi tidak ditemukan")
    
    return my_deteksi

# post deteksi lowongan (Updated with OpenAI - Always Run)
@router.post("/", response_model=schemas.DeteksiOut)
def deteksi_lowongan(
    deteksi_lowongan: schemas.DeteksiCreate, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    try:
        # 1. Preprocessing
        clean_judul = preprocess_text(deteksi_lowongan.judul)
        clean_perusahaan = preprocess_text(deteksi_lowongan.perusahaan)
        clean_deskripsi = preprocess_text(deteksi_lowongan.deskripsi)

        # Gabungkan text untuk analisis
        combined_text = f"Judul: {deteksi_lowongan.judul}\nPerusahaan: {deteksi_lowongan.perusahaan}\nDeskripsi: {deteksi_lowongan.deskripsi}"
        clean_combined_text = f"{clean_judul} {clean_perusahaan} {clean_deskripsi}"

        # 2. Rule-Based Analysis (always run first)
        rule_result = rule_based(clean_combined_text)
        
        # 3. OpenAI Assessment (always run if API key is available)
        use_openai = os.getenv("OPENAI_API_KEY") is not None
        
        if use_openai:
            try:
                # Always run OpenAI assessment regardless of rule-based results
                openai_result = get_openai_assessment(combined_text)
                
                # 4. Combine both assessments
                final_result = combine_assessments(rule_result, openai_result)
                
                hasil_final = final_result["label"]
                detail_alasan = "; ".join(final_result["alasan"][:5])  # Batasi panjang detail
                
            except Exception as e:
                print(f"OpenAI assessment failed: {e}")
                # Fallback to rule-based only if OpenAI fails
                hasil_final = rule_result["label"]
                detail_alasan = "; ".join(rule_result["alasan"]) if rule_result["alasan"] else "Analisis rule-based (OpenAI gagal)"
        else:
            # Use rule-based only if no OpenAI API key
            hasil_final = rule_result["label"]
            detail_alasan = "; ".join(rule_result["alasan"]) if rule_result["alasan"] else "Analisis rule-based (tidak ada OpenAI key)"

        # 5. Save to database
        new_deteksi = models.DeteksiLowongan(
            user_id=current_user.user_id,
            judul=clean_judul,
            perusahaan=clean_perusahaan,
            deskripsi=clean_deskripsi,
            hasil=hasil_final,
            detail=detail_alasan[:255],  # Limit detail length for database
            tanggal_deteksi=date.today(),
            create_at=datetime.now(),
            update_at=datetime.now()
        )
        
        db.add(new_deteksi)
        db.commit()
        db.refresh(new_deteksi)

        return new_deteksi
        
    except Exception as e:
        db.rollback()
        print(f"Error in deteksi_lowongan: {e}")
        raise HTTPException(status_code=500, detail="Terjadi kesalahan dalam proses deteksi")

# Advanced detection endpoint (optional - with detailed response)
@router.post("/advanced", response_model=dict)
def deteksi_lowongan_advanced(
    deteksi_lowongan: schemas.DeteksiCreate, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Endpoint dengan response yang lebih detail untuk debugging/development
    OpenAI selalu dijalankan jika tersedia
    """
    try:
        # 1. Preprocessing
        clean_judul = preprocess_text(deteksi_lowongan.judul)
        clean_perusahaan = preprocess_text(deteksi_lowongan.perusahaan)
        clean_deskripsi = preprocess_text(deteksi_lowongan.deskripsi)

        combined_text = f"Judul: {deteksi_lowongan.judul}\nPerusahaan: {deteksi_lowongan.perusahaan}\nDeskripsi: {deteksi_lowongan.deskripsi}"
        clean_combined_text = f"{clean_judul} {clean_perusahaan} {clean_deskripsi}"

        # 2. Rule-Based Analysis (always run first)
        rule_result = rule_based(clean_combined_text)
        
        # 3. OpenAI Assessment (always run if available)
        use_openai = os.getenv("OPENAI_API_KEY") is not None
        openai_result = None
        final_result = None
        
        if use_openai:
            try:
                # Always run OpenAI assessment
                openai_result = get_openai_assessment(combined_text)
                final_result = combine_assessments(rule_result, openai_result)
            except Exception as e:
                print(f"OpenAI assessment failed: {e}")
                final_result = {
                    "label": rule_result["label"],
                    "skor": rule_result["skor"],
                    "alasan": rule_result["alasan"] + ["OpenAI assessment gagal, menggunakan rule-based"],
                    "primary_method": "rule_based_fallback",
                    "openai_error": str(e)
                }
        else:
            final_result = {
                "label": rule_result["label"],
                "skor": rule_result["skor"],
                "alasan": rule_result["alasan"] + ["OpenAI tidak tersedia, menggunakan rule-based"],
                "primary_method": "rule_based_only",
                "openai_error": "API key tidak tersedia"
            }

        # 4. Save to database
        detail_alasan = "; ".join(final_result["alasan"][:5]) if final_result["alasan"] else "Analisis otomatis"
        
        new_deteksi = models.DeteksiLowongan(
            user_id=current_user.user_id,
            judul=clean_judul,
            perusahaan=clean_perusahaan,
            deskripsi=clean_deskripsi,
            hasil=final_result["label"],
            detail=detail_alasan[:255],
            tanggal_deteksi=date.today(),
            create_at=datetime.now(),
            update_at=datetime.now()
        )
        
        db.add(new_deteksi)
        db.commit()
        db.refresh(new_deteksi)

        # 5. Return detailed response
        return {
            "deteksi_result": {
                "deteksi_id": new_deteksi.deteksi_id,
                "user_id": new_deteksi.user_id,
                "judul": new_deteksi.judul,
                "perusahaan": new_deteksi.perusahaan,
                "deskripsi": new_deteksi.deskripsi,
                "hasil": new_deteksi.hasil,
                "detail": new_deteksi.detail,
                "tanggal_deteksi": new_deteksi.tanggal_deteksi.isoformat() if new_deteksi.tanggal_deteksi else None,
                "create_at": new_deteksi.create_at.isoformat() if new_deteksi.create_at else None,
                "update_at": new_deteksi.update_at.isoformat() if new_deteksi.update_at else None
            },
            "analysis_details": {
                "rule_based": rule_result,
                "openai_assessment": openai_result,
                "final_assessment": final_result,
                "openai_available": use_openai,
                "processing_flow": "rule_based -> openai -> combine" if use_openai and openai_result else "rule_based_only"
            },
            "preprocessing": {
                "original_text": combined_text,
                "cleaned_text": clean_combined_text
            }
        }
        
    except Exception as e:
        db.rollback()
        print(f"Error in advanced detection: {e}")
        raise HTTPException(status_code=500, detail=f"Terjadi kesalahan: {str(e)}")

# delete data deteksi
@router.delete("/{deteksi_id}", response_model=schemas.DeteksiOut)
def delete_deteksi(
    deteksi_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_required)
):
    db_deteksi = (
        db.query(models.DeteksiLowongan)
        .options(joinedload(models.DeteksiLowongan.user))
        .filter(models.DeteksiLowongan.deteksi_id == deteksi_id)
        .first()
    )

    if not db_deteksi:
        raise HTTPException(status_code=400, detail="deteksi lowongan tidak ditemukan")

    response_deteksi = schemas.DeteksiOut.from_orm(db_deteksi)

    db.delete(db_deteksi)
    db.commit()

    return response_deteksi