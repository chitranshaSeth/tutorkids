from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, JSON, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import enum

Base = declarative_base()

class Subject(str, enum.Enum):
    MATHEMATICS = "Mathematics"
    ENGLISH = "English"
    SCIENCE = "Science"
    SOCIAL_STUDIES = "Social Studies"
    ARTS = "Arts"

class Difficulty(str, enum.Enum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"

class MasteryLevel(str, enum.Enum):
    BEGINNER = "beginner"
    DEVELOPING = "developing"
    PROFICIENT = "proficient"
    ADVANCED = "advanced"

class ResourceType(str, enum.Enum):
    VIDEO = "video"
    WORKSHEET = "worksheet"
    INTERACTIVE = "interactive"
    READING = "reading"
    PRACTICE = "practice"

class Student(Base):
    __tablename__ = "students"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    grade = Column(Integer)
    age = Column(Integer)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    assessments = relationship("Assessment", back_populates="student")
    learning_plans = relationship("LearningPlan", back_populates="student")

class Assessment(Base):
    __tablename__ = "assessments"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("students.id"))
    subject = Column(Enum(Subject))
    score = Column(Integer)
    total_questions = Column(Integer)
    completed_date = Column(DateTime, default=datetime.utcnow)
    skill_breakdown = Column(JSON)
    recommendations = Column(JSON)
    
    student = relationship("Student", back_populates="assessments")
    questions = relationship("Question", back_populates="assessment")

class Question(Base):
    __tablename__ = "questions"

    id = Column(Integer, primary_key=True, index=True)
    assessment_id = Column(Integer, ForeignKey("assessments.id"))
    text = Column(String)
    options = Column(JSON)
    correct_answer = Column(Integer)
    explanation = Column(String)
    difficulty = Column(Enum(Difficulty))
    skill_category = Column(String)
    
    assessment = relationship("Assessment", back_populates="questions")

class LearningPlan(Base):
    __tablename__ = "learning_plans"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("students.id"))
    created_at = Column(DateTime, default=datetime.utcnow)
    target_date = Column(DateTime)
    
    student = relationship("Student", back_populates="learning_plans")
    subject_plans = relationship("SubjectPlan", back_populates="learning_plan")
    goals = relationship("LearningGoal", back_populates="learning_plan")
    resources = relationship("LearningResource", back_populates="learning_plan")

class SubjectPlan(Base):
    __tablename__ = "subject_plans"

    id = Column(Integer, primary_key=True, index=True)
    learning_plan_id = Column(Integer, ForeignKey("learning_plans.id"))
    subject = Column(Enum(Subject))
    progress = Column(Float)
    
    learning_plan = relationship("LearningPlan", back_populates="subject_plans")
    focus_areas = relationship("FocusArea", back_populates="subject_plan")
    weekly_goals = relationship("WeeklyGoal", back_populates="subject_plan")

class FocusArea(Base):
    __tablename__ = "focus_areas"

    id = Column(Integer, primary_key=True, index=True)
    subject_plan_id = Column(Integer, ForeignKey("subject_plans.id"))
    name = Column(String)
    description = Column(String)
    mastery_level = Column(Enum(MasteryLevel))
    
    subject_plan = relationship("SubjectPlan", back_populates="focus_areas")
    activities = relationship("LearningActivity", back_populates="focus_area")

class LearningActivity(Base):
    __tablename__ = "learning_activities"

    id = Column(Integer, primary_key=True, index=True)
    focus_area_id = Column(Integer, ForeignKey("focus_areas.id"))
    title = Column(String)
    description = Column(String)
    duration = Column(Integer)  # in seconds
    difficulty = Column(Enum(Difficulty))
    resource_type = Column(Enum(ResourceType))
    url = Column(String, nullable=True)
    
    focus_area = relationship("FocusArea", back_populates="activities")

class WeeklyGoal(Base):
    __tablename__ = "weekly_goals"

    id = Column(Integer, primary_key=True, index=True)
    subject_plan_id = Column(Integer, ForeignKey("subject_plans.id"))
    description = Column(String)
    is_completed = Column(Integer, default=0)
    target_date = Column(DateTime)
    
    subject_plan = relationship("SubjectPlan", back_populates="weekly_goals")

class LearningGoal(Base):
    __tablename__ = "learning_goals"

    id = Column(Integer, primary_key=True, index=True)
    learning_plan_id = Column(Integer, ForeignKey("learning_plans.id"))
    description = Column(String)
    target_date = Column(DateTime)
    progress = Column(Float)
    
    learning_plan = relationship("LearningPlan", back_populates="goals")
    milestones = relationship("Milestone", back_populates="learning_goal")

class Milestone(Base):
    __tablename__ = "milestones"

    id = Column(Integer, primary_key=True, index=True)
    learning_goal_id = Column(Integer, ForeignKey("learning_goals.id"))
    description = Column(String)
    is_completed = Column(Integer, default=0)
    target_date = Column(DateTime)
    
    learning_goal = relationship("LearningGoal", back_populates="milestones")

class LearningResource(Base):
    __tablename__ = "learning_resources"

    id = Column(Integer, primary_key=True, index=True)
    learning_plan_id = Column(Integer, ForeignKey("learning_plans.id"))
    title = Column(String)
    description = Column(String)
    type = Column(Enum(ResourceType))
    url = Column(String)
    subject = Column(Enum(Subject))
    difficulty = Column(Enum(Difficulty))
    
    learning_plan = relationship("LearningPlan", back_populates="resources") 