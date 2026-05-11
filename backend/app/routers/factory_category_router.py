from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.schemas.factory_category import FactoryCategoryCreate, FactoryCategoryUpdate, FactoryCategoryResponse
import app.services.factory_category_service as service

router = APIRouter(prefix="/api/v1/categories", tags=["Factory Categories"])

@router.get("/", response_model=List[FactoryCategoryResponse])
def list_categories(db: Session = Depends(get_db)):
    return service.get_all(db)

@router.get("/{category_id}", response_model=FactoryCategoryResponse)
def get_category(category_id: int, db: Session = Depends(get_db)):
    return service.get_by_id(db, category_id)

@router.post("/", response_model=FactoryCategoryResponse, status_code=201)
def create_category(data: FactoryCategoryCreate, db: Session = Depends(get_db)):
    return service.create(db, data)

@router.put("/{category_id}", response_model=FactoryCategoryResponse)
def update_category(category_id: int, data: FactoryCategoryUpdate, db: Session = Depends(get_db)):
    return service.update(db, category_id, data)

@router.delete("/{category_id}", status_code=204)
def delete_category(category_id: int, db: Session = Depends(get_db)):
    service.delete(db, category_id)
