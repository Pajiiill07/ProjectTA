from fastapi import APIRouter, Depends, Response, HTTPException
from sqlalchemy.orm import Session
from jinja2 import Environment, FileSystemLoader
from weasyprint import HTML
from app.database.mysql import get_db
from app.utils.auth_set import get_current_user
from app.models import user, data_user, riwayat_pendidikan, pengalaman, keahlian
import io
import os
from datetime import datetime

router = APIRouter()

# Setup Jinja2 environment
template_dir = "app/template"
if not os.path.exists(template_dir):
    os.makedirs(template_dir)
    
env = Environment(loader=FileSystemLoader(template_dir))

@router.get("/generate-cv", response_class=Response)
async def generate_cv(db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    try:
        # Ambil data user yang sedang login
        user_data = db.query(user.User).filter(user.User.user_id == current_user.user_id).first()
        if not user_data:
            raise HTTPException(status_code=404, detail="Data user tidak ditemukan")
        
        # Ambil data profil user
        datauser_data = db.query(data_user.DataUser).filter(data_user.DataUser.user_id == current_user.user_id).first()
        if not datauser_data:
            raise HTTPException(status_code=404, detail="Data profil user tidak ditemukan")
        
        # Ambil data pendidikan (diurutkan berdasarkan tahun terbaru)
        pendidikan_data = db.query(riwayat_pendidikan.Riwayat_Pendidikan)\
            .filter(riwayat_pendidikan.Riwayat_Pendidikan.user_id == current_user.user_id)\
            .order_by(riwayat_pendidikan.Riwayat_Pendidikan.tahun_selesai.desc())\
            .all()
        
        # Ambil data pengalaman (diurutkan berdasarkan tanggal terbaru)
        pengalaman_data = db.query(pengalaman.Pengalaman)\
            .filter(pengalaman.Pengalaman.user_id == current_user.user_id)\
            .order_by(pengalaman.Pengalaman.tanggal_kegiatan.desc())\
            .all()
        
        # Ambil data keahlian/skill
        skill_data = db.query(keahlian.Keahlian)\
            .filter(keahlian.Keahlian.user_id == current_user.user_id)\
            .all()
        
        # Load template CV
        try:
            template = env.get_template("cv_template.html")
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Template CV tidak ditemukan: {str(e)}")
        
        # Render template dengan data user
        html_content = template.render(
            user=user_data,
            data_user=datauser_data,
            pendidikan=pendidikan_data,
            pengalaman=pengalaman_data,
            skills=skill_data,
            current_date=datetime.now().strftime("%Y-%m-%d")
        )
        
        # Generate PDF dari HTML
        try:
            pdf_bytes = HTML(string=html_content, base_url="").write_pdf()
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Gagal generate PDF: {str(e)}")
        
        # Buat nama file yang aman
        safe_filename = "".join(c for c in datauser_data.nama_lengkap if c.isalnum() or c in (' ', '-', '_')).rstrip()
        safe_filename = safe_filename.replace(' ', '_')
        
        return Response(
            content=pdf_bytes,
            media_type="application/pdf",
            headers={
                "Content-Disposition": f"attachment; filename=CV_{safe_filename}.pdf",
                "Content-Length": str(len(pdf_bytes))
            }
        )
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Terjadi kesalahan: {str(e)}")


# Route tambahan untuk preview CV dalam format HTML
@router.get("/preview-cv", response_class=Response)
async def preview_cv(db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    try:
        # Ambil data user yang sedang login
        user_data = db.query(user.User).filter(user.User.user_id == current_user.user_id).first()
        if not user_data:
            raise HTTPException(status_code=404, detail="Data user tidak ditemukan")
        
        # Ambil data profil user
        datauser_data = db.query(data_user.DataUser).filter(data_user.DataUser.user_id == current_user.user_id).first()
        if not datauser_data:
            raise HTTPException(status_code=404, detail="Data profil user tidak ditemukan")
        
        # Ambil data pendidikan
        pendidikan_data = db.query(riwayat_pendidikan.Riwayat_Pendidikan)\
            .filter(riwayat_pendidikan.Riwayat_Pendidikan.user_id == current_user.user_id)\
            .order_by(riwayat_pendidikan.Riwayat_Pendidikan.tahun_selesai.desc())\
            .all()
        
        # Ambil data pengalaman
        pengalaman_data = db.query(pengalaman.Pengalaman)\
            .filter(pengalaman.Pengalaman.user_id == current_user.user_id)\
            .order_by(pengalaman.Pengalaman.tanggal_kegiatan.desc())\
            .all()
        
        # Ambil data keahlian
        skill_data = db.query(keahlian.Keahlian)\
            .filter(keahlian.Keahlian.user_id == current_user.user_id)\
            .all()
        
        # Load template CV
        template = env.get_template("cv_template.html")
        
        # Render template
        html_content = template.render(
            user=user_data,
            data_user=datauser_data,
            pendidikan=pendidikan_data,
            pengalaman=pengalaman_data,
            skills=skill_data,
            current_date=datetime.now().strftime("%Y-%m-%d")
        )
        
        return Response(
            content=html_content,
            media_type="text/html"
        )
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Terjadi kesalahan: {str(e)}")