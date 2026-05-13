import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from app.routers import factory_router, factory_category_router, product_router, model_router
from app.routers.upload_router import router as upload_router
from app.core.database import Base, engine

STATIC_DIR = "/app/static"
os.makedirs(f"{STATIC_DIR}/images", exist_ok=True)

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Factory Management API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

app.include_router(factory_category_router.router)
app.include_router(factory_router.router)
app.include_router(product_router.router)
app.include_router(model_router.router)
app.include_router(upload_router)

@app.get("/health")
def health_check():
    return {"status": "ok"}
