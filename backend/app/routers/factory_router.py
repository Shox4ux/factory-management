from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.schemas.factory import FactoryCreate, FactoryUpdate, FactoryResponse
import app.services.factory_service as service

router = APIRouter(prefix="/api/v1/factories", tags=["Factories"])

@router.get("/", response_model=List[FactoryResponse])
def list_factories(
    name: Optional[str] = Query(None),
    product_name: Optional[str] = Query(None),
    category: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    return service.get_all(db, name=name, product_name=product_name, category=category)

@router.get("/{factory_id}", response_model=FactoryResponse)
def get_factory(factory_id: int, db: Session = Depends(get_db)):
    return service.get_by_id(db, factory_id)

@router.post("/", response_model=FactoryResponse, status_code=201)
def create_factory(data: FactoryCreate, db: Session = Depends(get_db)):
    return service.create(db, data)

@router.put("/{factory_id}", response_model=FactoryResponse)
def update_factory(factory_id: int, data: FactoryUpdate, db: Session = Depends(get_db)):
    return service.update(db, factory_id, data)

@router.delete("/{factory_id}", status_code=204)
def delete_factory(factory_id: int, db: Session = Depends(get_db)):
    service.delete(db, factory_id)
