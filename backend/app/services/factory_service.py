from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from app.models.factory import Factory
from app.models.product import Product
from app.models.model import Model
from app.models.factory_category import FactoryCategory
from app.schemas.factory import FactoryCreate, FactoryUpdate
from fastapi import HTTPException, status

def get_all(db: Session, name: Optional[str] = None, product_name: Optional[str] = None, category: Optional[str] = None) -> List[Factory]:
    query = db.query(Factory).options(
        joinedload(Factory.factory_category),
        joinedload(Factory.products).joinedload(Product.models)
    )
    if name:
        query = query.filter(Factory.name.ilike(f"%{name}%"))
    if product_name:
        query = query.join(Factory.products).filter(Product.name.ilike(f"%{product_name}%"))
    if category:
        query = query.join(Factory.factory_category).filter(FactoryCategory.category_name.ilike(f"%{category}%"))
    return query.all()

def get_by_id(db: Session, factory_id: int) -> Factory:
    factory = db.query(Factory).options(
        joinedload(Factory.factory_category),
        joinedload(Factory.products).joinedload(Product.models)
    ).filter(Factory.id == factory_id).first()
    if not factory:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Factory not found")
    return factory

def create(db: Session, data: FactoryCreate) -> Factory:
    factory = Factory(**data.model_dump(exclude={'products'}))
    db.add(factory)
    db.flush()
    for p_data in data.products:
        product = Product(name=p_data.name, factory_id=factory.id)
        db.add(product)
        db.flush()
        for m_data in p_data.models:
            db.add(Model(**m_data.model_dump(), product_id=product.id))
    db.commit()
    return get_by_id(db, factory.id)

def update(db: Session, factory_id: int, data: FactoryUpdate) -> Factory:
    factory = get_by_id(db, factory_id)
    for field, value in data.model_dump(exclude_unset=True, exclude={'products'}).items():
        setattr(factory, field, value)
    if data.products is not None:
        factory.products.clear()
        db.flush()
        for p_data in data.products:
            product = Product(name=p_data.name, factory_id=factory_id)
            db.add(product)
            db.flush()
            for m_data in p_data.models:
                db.add(Model(**m_data.model_dump(), product_id=product.id))
    db.commit()
    return get_by_id(db, factory_id)

def delete(db: Session, factory_id: int) -> None:
    factory = get_by_id(db, factory_id)
    db.delete(factory)
    db.commit()
