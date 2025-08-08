from sqlalchemy import Column, Integer, String, Enum, Date, TIMESTAMP, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.database.session import Base
from sqlalchemy.sql import func

class EduKonten(Base):
    __tablename__= "edukontens"

    konten_id = Column(Integer, primary_key=True, index=True)
    judul = Column(String(255))
    isi = Column(Text)
    kategori = Column(Enum('Artikel', 'Tips'))
    sumber = Column(String(100))
    create_at = Column(TIMESTAMP, server_default=func.now())
    update_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())
