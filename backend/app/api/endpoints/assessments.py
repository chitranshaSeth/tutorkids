from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Dict
from ...database import get_db
from ...models import Assessment, Student, Subject, User
from ...schemas import AssessmentCreate, Assessment as AssessmentSchema
from ...services.assessment_analyzer import AssessmentAnalyzer
from ...core.auth import get_current_active_user, get_current_admin_user

router = APIRouter()
analyzer = AssessmentAnalyzer()

@router.post("/assessments/", response_model=AssessmentSchema)
def create_assessment(
    assessment: AssessmentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Submit a new assessment and get analysis results."""
    # Verify student exists and belongs to the current user
    student = db.query(Student).filter(
        Student.id == assessment.student_id,
        Student.user_id == current_user.id
    ).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    
    # Analyze assessment
    skill_breakdown, recommendations = analyzer.analyze_assessment(assessment)
    learning_style = analyzer.predict_learning_style(assessment)
    mastery_level = analyzer.calculate_mastery_level(assessment.score)
    
    # Create assessment record
    db_assessment = Assessment(
        student_id=assessment.student_id,
        subject=assessment.subject,
        score=assessment.score,
        total_questions=len(assessment.questions),
        skill_breakdown=skill_breakdown,
        recommendations=recommendations,
        learning_style=learning_style,
        mastery_level=mastery_level
    )
    
    db.add(db_assessment)
    db.commit()
    db.refresh(db_assessment)
    
    return db_assessment

@router.get("/assessments/{assessment_id}", response_model=AssessmentSchema)
def get_assessment(
    assessment_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get assessment details by ID."""
    assessment = db.query(Assessment).join(Student).filter(
        Assessment.id == assessment_id,
        Student.user_id == current_user.id
    ).first()
    if not assessment:
        raise HTTPException(status_code=404, detail="Assessment not found")
    return assessment

@router.get("/students/{student_id}/assessments", response_model=List[AssessmentSchema])
def get_student_assessments(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get all assessments for a specific student."""
    # Verify student belongs to the current user
    student = db.query(Student).filter(
        Student.id == student_id,
        Student.user_id == current_user.id
    ).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    
    assessments = db.query(Assessment).filter(Assessment.student_id == student_id).all()
    return assessments

@router.get("/assessments/subject/{subject}", response_model=List[AssessmentSchema])
def get_subject_assessments(
    subject: Subject,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """Get all assessments for a specific subject."""
    assessments = db.query(Assessment).join(Student).filter(
        Assessment.subject == subject,
        Student.user_id == current_user.id
    ).all()
    return assessments

@router.get("/assessments/analysis/clusters", response_model=Dict[int, List[int]])
def get_student_clusters(
    n_clusters: int = 3,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Get student clusters based on assessment performance (admin only)."""
    assessments = db.query(Assessment).all()
    if not assessments:
        raise HTTPException(status_code=404, detail="No assessments found")
    
    assessment_data = [
        AssessmentCreate(
            student_id=assessment.student_id,
            subject=assessment.subject,
            score=assessment.score,
            questions=assessment.questions
        ) for assessment in assessments
    ]
    
    clusters = analyzer.cluster_students(assessment_data, n_clusters)
    return clusters

@router.get("/assessments/analysis/learning-styles")
def get_learning_style_distribution(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Get distribution of learning styles across all students (admin only)."""
    assessments = db.query(Assessment).all()
    if not assessments:
        raise HTTPException(status_code=404, detail="No assessments found")
    
    learning_styles = {}
    for assessment in assessments:
        style = assessment.learning_style
        learning_styles[style] = learning_styles.get(style, 0) + 1
    
    return learning_styles

@router.get("/assessments/analysis/mastery-levels")
def get_mastery_level_distribution(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Get distribution of mastery levels across all students (admin only)."""
    assessments = db.query(Assessment).all()
    if not assessments:
        raise HTTPException(status_code=404, detail="No assessments found")
    
    mastery_levels = {}
    for assessment in assessments:
        level = assessment.mastery_level
        mastery_levels[level] = mastery_levels.get(level, 0) + 1
    
    return mastery_levels 