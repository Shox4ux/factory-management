from pydantic import BaseModel
from typing import Optional, List
from app.schemas.model import ModelResponse, ModelCreateNested

class ProductBase(BaseModel):
    name: str

class ProductCreateNested(ProductBase):
    models: List[ModelCreateNested] = []

class ProductCreate(ProductBase):
    factory_id: int
    models: List[ModelCreateNested] = []

class ProductUpdate(BaseModel):
    name: Optional[str] = None
    factory_id: Optional[int] = None
    models: Optional[List[ModelCreateNested]] = None

class ProductResponse(ProductBase):
    id: int
    factory_id: int
    models: List[ModelResponse] = []
    class Config:
        from_attributes = True
