from sqlalchemy import Column, Integer, String, Text, Enum, ForeignKey, Date, TIMESTAMP
from sqlalchemy.orm import relationship
from app.database.session import Base
from sqlalchemy.sql import func

class DeteksiLowongan(Base):
    __tablename__ = "deteksi_lowongans"

    deteksi_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id"))
    judul = Column(String(255))
    perusahaan = Column(String(100))
    deskripsi = Column(Text)
    hasil = Column(Enum('asli', 'palsu'))
    detail = Column(String(255))
    tanggal_deteksi = Column(Date)
    create_at = Column(TIMESTAMP, server_default=func.now())
    update_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="deteksi")