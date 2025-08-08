from sqlalchemy import Column, Integer, String, TIMESTAMP, ForeignKey, Date
from sqlalchemy.orm import relationship
from app.database.session import Base
from sqlalchemy.sql import func

class Pengalaman(Base):
    __tablename__= "pengalamans"

    pengalaman_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id"))
    judul = Column(String(100))
    instansi = Column(String(100))
    tanggal_kegiatan = Column(Date)
    keterangan = Column(String(255))
    create_at = Column(TIMESTAMP, server_default=func.now())
    update_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="pengalaman")