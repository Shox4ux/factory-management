from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base

class Factory(Base):
    __tablename__ = "factories"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, index=True)
    phone = Column(String, nullable=True)
    wechat_id = Column(String, nullable=True)
    address = Column(String, nullable=True)
    factory_category_id = Column(Integer, ForeignKey("factory_categories.id"), nullable=False)
    factory_category = relationship("FactoryCategory", back_populates="factories")
    products = relationship("Product", back_populates="factory", cascade="all, delete-orphan")
