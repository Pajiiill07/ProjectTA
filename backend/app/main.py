from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database.session import Base
from app.database.mysql import engine
from app.routes.users import router as usroutes
from app.routes.datausers import router as dusroutes
from app.routes.keahlians import router as khlroutes
from app.routes.pengalamans import router as pglroutes
from app.routes.riwayatpendidikans import router as rwytroutes
from app.routes.edukontens import router as edukonrouter
from app.routes.auth import router as loginrouter
from app.routes.deteksilowongans import router as deteksirouter
from app.routes.datasetlabeleds import router as datasetroutes
from app.routes.build_cv import router as buildcv
from fastapi.staticfiles import StaticFiles

app = FastAPI()

Base.metadata.create_all(bind=engine)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return{"Aloowww"}

app.mount("/static", StaticFiles(directory="app/static"), name="static")

app.include_router(usroutes,prefix="/users", tags=["Users"])
app.include_router(dusroutes,prefix="/data_users", tags=["DataUsers"])
app.include_router(khlroutes,prefix="/keahlians", tags=["Keahlians"])
app.include_router(pglroutes,prefix="/pengalamans", tags=["Pengalamans"])
app.include_router(rwytroutes, prefix="/riwayat_pendidikans", tags=["RiwayatPendidikans"])
app.include_router(edukonrouter, prefix="/edu_kontens", tags=["EduKontens"])
app.include_router(loginrouter, prefix="/auth", tags=["Auth"])
app.include_router(deteksirouter, prefix="/deteksi", tags=["DeteksiLowongans"])
app.include_router(datasetroutes, prefix="/datasets", tags="DatasetLabeleds")
app.include_router(buildcv, prefix="/cv", tags="BuildCv")