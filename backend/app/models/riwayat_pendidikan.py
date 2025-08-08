from sqlalchemy import Column, Integer, String, Date, Enum, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from app.database.session import Base
from sqlalchemy.sql import func
from app.schemas.riwayatpen_sch import JenjangEnum

class Riwayat_Pendidikan(Base):
    __tablename__= "riwayat_pendidikans"

    riwayat_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id"))
    jenjang = Column(Enum(JenjangEnum), nullable=False)
    instansi = Column(String(100))
    jurusan = Column(String(100))
    tahun_mulai = Column(Date)
    tahun_selesai = Column(Date, nullable=True)
    create_at = Column(TIMESTAMP, server_default=func.now())
    update_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="riwayatpendidikan")