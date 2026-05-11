from sqlalchemy.orm import Session
from typing import List
from app.models.model import Model
from app.schemas.model import ModelCreate, ModelUpdate
from fastapi import HTTPException, status

def get_all(db: Session) -> List[Model]:
    return db.query(Model).all()

def get_by_id(db: Session, model_id: int) -> Model:
    model = db.query(Model).filter(Model.id == model_id).first()
    if not model:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Model not found")
    return model

def create(db: Session, data: ModelCreate) -> Model:
    model = Model(**data.model_dump())
    db.add(model)
    db.commit()
    db.refresh(model)
    return model

def update(db: Session, model_id: int, data: ModelUpdate) -> Model:
    model = get_by_id(db, model_id)
    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(model, field, value)
    db.commit()
    db.refresh(model)
    return model

def delete(db: Session, model_id: int) -> None:
    model = get_by_id(db, model_id)
    db.delete(model)
    db.commit()
