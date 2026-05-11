from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from app.core.database import Base

class FactoryCategory(Base):
    __tablename__ = "factory_categories"
    id = Column(Integer, primary_key=True, index=True)
    category_name = Column(String, unique=True, nullable=False, index=True)
    factories = relationship("Factory", back_populates="factory_category", cascade="all, delete-orphan")
