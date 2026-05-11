from sqlalchemy.orm import Session
from typing import List
from app.models.product import Product
from app.models.model import Model
from app.schemas.product import ProductCreate, ProductUpdate
from fastapi import HTTPException, status

def get_all(db: Session) -> List[Product]:
    return db.query(Product).all()

def get_by_id(db: Session, product_id: int) -> Product:
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Product not found")
    return product

def create(db: Session, data: ProductCreate) -> Product:
    product = Product(name=data.name, factory_id=data.factory_id)
    db.add(product)
    db.flush()
    for m_data in data.models:
        db.add(Model(**m_data.model_dump(), product_id=product.id))
    db.commit()
    db.refresh(product)
    return product

def update(db: Session, product_id: int, data: ProductUpdate) -> Product:
    product = get_by_id(db, product_id)
    if data.name is not None:
        product.name = data.name
    if data.factory_id is not None:
        product.factory_id = data.factory_id
    if data.models is not None:
        product.models.clear()
        db.flush()
        for m_data in data.models:
            db.add(Model(**m_data.model_dump(), product_id=product_id))
    db.commit()
    db.refresh(product)
    return product

def delete(db: Session, product_id: int) -> None:
    product = get_by_id(db, product_id)
    db.delete(product)
    db.commit()
