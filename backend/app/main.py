from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .api.endpoints import assessments, auth
from .database import engine, Base
from .core.config import settings

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="API for managing student assessments and generating personalized learning plans",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix=f"{settings.API_V1_PREFIX}/auth", tags=["auth"])
app.include_router(assessments.router, prefix=settings.API_V1_PREFIX, tags=["assessments"])

@app.get("/")
async def root():
    """Root endpoint returning API information."""
    return {
        "name": settings.PROJECT_NAME,
        "version": "1.0.0",
        "description": "API for managing student assessments and generating personalized learning plans",
        "endpoints": {
            "auth": {
                "login": f"{settings.API_V1_PREFIX}/auth/login",
                "register": f"{settings.API_V1_PREFIX}/auth/register",
                "me": f"{settings.API_V1_PREFIX}/auth/me"
            },
            "assessments": {
                "create": f"{settings.API_V1_PREFIX}/assessments/",
                "get": f"{settings.API_V1_PREFIX}/assessments/{{assessment_id}}",
                "student": f"{settings.API_V1_PREFIX}/students/{{student_id}}/assessments",
                "subject": f"{settings.API_V1_PREFIX}/assessments/subject/{{subject}}",
                "analysis": {
                    "clusters": f"{settings.API_V1_PREFIX}/assessments/analysis/clusters",
                    "learning_styles": f"{settings.API_V1_PREFIX}/assessments/analysis/learning-styles",
                    "mastery_levels": f"{settings.API_V1_PREFIX}/assessments/analysis/mastery-levels"
                }
            }
        }
    } 