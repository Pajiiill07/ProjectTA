from sqlalchemy import Column, Integer, String,Text, Enum, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from app.database.session import Base
from sqlalchemy.sql import func

class DatasetLabeled(Base):
    __tablename__= "dataset_labeleds"

    dataset_id = Column(Integer, primary_key=True, index=True)
    judul = Column(String(255))
    perusahaan = Column(String(100))
    deskripsi = Column(Text)
    label = Column(Enum('asli', 'palsu'))
    create_at = Column(TIMESTAMP, server_default=func.now())
    update_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

