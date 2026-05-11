from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.schemas.model import ModelCreate, ModelUpdate, ModelResponse
import app.services.model_service as service

router = APIRouter(prefix="/api/v1/models", tags=["Models"])

@router.get("/", response_model=List[ModelResponse])
def list_models(db: Session = Depends(get_db)):
    return service.get_all(db)

@router.get("/{model_id}", response_model=ModelResponse)
def get_model(model_id: int, db: Session = Depends(get_db)):
    return service.get_by_id(db, model_id)

@router.post("/", response_model=ModelResponse, status_code=201)
def create_model(data: ModelCreate, db: Session = Depends(get_db)):
    return service.create(db, data)

@router.put("/{model_id}", response_model=ModelResponse)
def update_model(model_id: int, data: ModelUpdate, db: Session = Depends(get_db)):
    return service.update(db, model_id, data)

@router.delete("/{model_id}", status_code=204)
def delete_model(model_id: int, db: Session = Depends(get_db)):
    service.delete(db, model_id)
