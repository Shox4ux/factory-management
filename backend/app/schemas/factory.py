from pydantic import BaseModel
from typing import Optional, List
from app.schemas.product import ProductResponse, ProductCreateNested
from app.schemas.factory_category import FactoryCategoryResponse

class FactoryBase(BaseModel):
    name: str
    phone: Optional[str] = None
    wechat_id: Optional[str] = None
    address: Optional[str] = None
    factory_category_id: int

class FactoryCreate(FactoryBase):
    products: List[ProductCreateNested] = []

class FactoryUpdate(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    wechat_id: Optional[str] = None
    address: Optional[str] = None
    factory_category_id: Optional[int] = None
    products: Optional[List[ProductCreateNested]] = None

class FactoryResponse(FactoryBase):
    id: int
    factory_category: Optional[FactoryCategoryResponse] = None
    products: List[ProductResponse] = []
    class Config:
        from_attributes = True
