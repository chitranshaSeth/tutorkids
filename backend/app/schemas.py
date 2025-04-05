from pydantic import BaseModel, Field
from typing import List, Optional, Dict
from datetime import datetime
from .models import Subject, Difficulty, MasteryLevel, ResourceType

class StudentBase(BaseModel):
    name: str
    grade: int
    age: int

class StudentCreate(StudentBase):
    pass

class Student(StudentBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

class QuestionBase(BaseModel):
    text: str
    options: List[str]
    correct_answer: int
    explanation: str
    difficulty: Difficulty
    skill_category: str

class QuestionCreate(QuestionBase):
    pass

class Question(QuestionBase):
    id: int
    assessment_id: int

    class Config:
        from_attributes = True

class AssessmentBase(BaseModel):
    subject: Subject
    score: int
    total_questions: int
    skill_breakdown: Dict[str, int]
    recommendations: List[str]

class AssessmentCreate(AssessmentBase):
    student_id: int
    questions: List[QuestionCreate]

class Assessment(AssessmentBase):
    id: int
    student_id: int
    completed_date: datetime
    questions: List[Question]

    class Config:
        from_attributes = True

class LearningActivityBase(BaseModel):
    title: str
    description: str
    duration: int
    difficulty: Difficulty
    resource_type: ResourceType
    url: Optional[str] = None

class LearningActivityCreate(LearningActivityBase):
    pass

class LearningActivity(LearningActivityBase):
    id: int
    focus_area_id: int

    class Config:
        from_attributes = True

class FocusAreaBase(BaseModel):
    name: str
    description: str
    mastery_level: MasteryLevel
    activities: List[LearningActivityCreate]

class FocusAreaCreate(FocusAreaBase):
    pass

class FocusArea(FocusAreaBase):
    id: int
    subject_plan_id: int
    activities: List[LearningActivity]

    class Config:
        from_attributes = True

class WeeklyGoalBase(BaseModel):
    description: str
    target_date: datetime
    is_completed: bool = False

class WeeklyGoalCreate(WeeklyGoalBase):
    pass

class WeeklyGoal(WeeklyGoalBase):
    id: int
    subject_plan_id: int

    class Config:
        from_attributes = True

class SubjectPlanBase(BaseModel):
    subject: Subject
    progress: float
    focus_areas: List[FocusAreaCreate]
    weekly_goals: List[WeeklyGoalCreate]

class SubjectPlanCreate(SubjectPlanBase):
    pass

class SubjectPlan(SubjectPlanBase):
    id: int
    learning_plan_id: int
    focus_areas: List[FocusArea]
    weekly_goals: List[WeeklyGoal]

    class Config:
        from_attributes = True

class MilestoneBase(BaseModel):
    description: str
    target_date: datetime
    is_completed: bool = False

class MilestoneCreate(MilestoneBase):
    pass

class Milestone(MilestoneBase):
    id: int
    learning_goal_id: int

    class Config:
        from_attributes = True

class LearningGoalBase(BaseModel):
    description: str
    target_date: datetime
    progress: float
    milestones: List[MilestoneCreate]

class LearningGoalCreate(LearningGoalBase):
    pass

class LearningGoal(LearningGoalBase):
    id: int
    learning_plan_id: int
    milestones: List[Milestone]

    class Config:
        from_attributes = True

class LearningResourceBase(BaseModel):
    title: str
    description: str
    type: ResourceType
    url: str
    subject: Subject
    difficulty: Difficulty

class LearningResourceCreate(LearningResourceBase):
    pass

class LearningResource(LearningResourceBase):
    id: int
    learning_plan_id: int

    class Config:
        from_attributes = True

class LearningPlanBase(BaseModel):
    target_date: datetime
    subjects: List[SubjectPlanCreate]
    goals: List[LearningGoalCreate]
    resources: List[LearningResourceCreate]

class LearningPlanCreate(LearningPlanBase):
    student_id: int

class LearningPlan(LearningPlanBase):
    id: int
    student_id: int
    created_at: datetime
    subjects: List[SubjectPlan]
    goals: List[LearningGoal]
    resources: List[LearningResource]

    class Config:
        from_attributes = True 