from sqlalchemy import Column, Integer, String, Enum, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from app.database.session import Base
from sqlalchemy.sql import func

class Keahlian(Base):
    __tablename__= "keahlians"

    keahlian_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id"))
    nama_skill = Column(String(255))
    kategori = Column(Enum('Soft Skill', 'Hard Skill'))
    create_at = Column(TIMESTAMP, server_default=func.now())
    update_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="keahlian")