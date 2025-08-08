from sqlalchemy import Column, Integer, String, ForeignKey, TIMESTAMP
from sqlalchemy.orm import relationship
from app.database.session import Base
from sqlalchemy.sql import func

class DataUser(Base):
    __tablename__ = "data_users"

    data_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id"))
    nama_lengkap = Column(String(50))
    no_telp = Column(String(13))
    linkedin = Column(String(100))
    alamat = Column(String(100))
    summary = Column(String(255))
    create_at = Column(TIMESTAMP, server_default=func.now())
    update_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="datauser")