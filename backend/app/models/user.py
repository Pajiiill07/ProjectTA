from sqlalchemy import Column, Integer, String, Enum, TIMESTAMP
from sqlalchemy.orm import relationship
from app.database.session import Base
from app.utils.role_enum import UserRoleEnum
from sqlalchemy.sql import func

class User(Base):
    __tablename__ = "users"

    user_id = Column(Integer, primary_key=True, index=True)
    username = Column(String(30), unique=True, index=True)
    email = Column(String(50), unique=True, index=True)
    password = Column(String(255))
    role = Column(Enum(UserRoleEnum))
    photo_url = Column(String(255), nullable=True)
    create_at = Column(TIMESTAMP, server_default=func.now())
    update_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    datauser = relationship("DataUser", back_populates="user")
    keahlian = relationship("Keahlian", back_populates="user")
    pengalaman = relationship("Pengalaman", back_populates="user")
    riwayatpendidikan = relationship("Riwayat_Pendidikan", back_populates="user")
    deteksi = relationship("DeteksiLowongan", back_populates="user")