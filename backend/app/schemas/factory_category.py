from pydantic import BaseModel
from typing import Optional

class FactoryCategoryBase(BaseModel):
    category_name: str

class FactoryCategoryCreate(FactoryCategoryBase):
    pass

class FactoryCategoryUpdate(BaseModel):
    category_name: Optional[str] = None

class FactoryCategoryResponse(FactoryCategoryBase):
    id: int
    class Config:
        from_attributes = True
