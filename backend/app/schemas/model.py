from pydantic import BaseModel
from typing import Optional
from decimal import Decimal

class ModelBase(BaseModel):
    name: str
    price: Decimal
    info: str
    images: Optional[str] = None

class ModelCreateNested(ModelBase):
    pass

class ModelCreate(ModelBase):
    product_id: int

class ModelUpdate(BaseModel):
    name: Optional[str] = None
    price: Optional[Decimal] = None
    info: Optional[str] = None
    images: Optional[str] = None

class ModelResponse(ModelBase):
    id: int
    product_id: int
    class Config:
        from_attributes = True
