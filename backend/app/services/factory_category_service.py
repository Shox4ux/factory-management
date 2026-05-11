from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.factory_category import FactoryCategory
from app.schemas.factory_category import FactoryCategoryCreate, FactoryCategoryUpdate
from fastapi import HTTPException, status

def get_all(db: Session) -> List[FactoryCategory]:
    return db.query(FactoryCategory).all()

def get_by_id(db: Session, category_id: int) -> FactoryCategory:
    category = db.query(FactoryCategory).filter(FactoryCategory.id == category_id).first()
    if not category:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Category not found")
    return category

def create(db: Session, data: FactoryCategoryCreate) -> FactoryCategory:
    existing = db.query(FactoryCategory).filter(FactoryCategory.category_name == data.category_name).first()
    if existing:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Category already exists")
    category = FactoryCategory(**data.model_dump())
    db.add(category)
    db.commit()
    db.refresh(category)
    return category

def update(db: Session, category_id: int, data: FactoryCategoryUpdate) -> FactoryCategory:
    category = get_by_id(db, category_id)
    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(category, field, value)
    db.commit()
    db.refresh(category)
    return category

def delete(db: Session, category_id: int) -> None:
    category = get_by_id(db, category_id)
    db.delete(category)
    db.commit()
