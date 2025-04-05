import numpy as np
from sklearn.cluster import KMeans
from typing import List, Dict, Tuple
from ..models import Subject, Difficulty, MasteryLevel
from ..schemas import AssessmentCreate, Question

class AssessmentAnalyzer:
    def __init__(self):
        self.skill_weights = {
            "Number Operations": 1.2,
            "Pattern and Function": 1.0,
            "Shape and Space": 1.0,
            "Data Handling": 0.8,
            "Reading": 1.2,
            "Writing": 1.0,
            "Speaking": 0.8,
            "Listening": 0.8,
            "Viewing": 0.6,
            "Presenting": 0.6,
            "Living Things": 1.0,
            "Materials and Matter": 1.0,
            "Forces and Energy": 1.0,
            "Earth and Space": 1.0,
            "Human Systems": 1.0,
            "Social Organization": 0.8,
            "Culture": 0.8,
            "Time, Continuity and Change": 1.0,
            "Visual Arts": 0.8,
            "Music": 0.8,
            "Drama": 0.8,
            "Dance": 0.8
        }

    def analyze_assessment(self, assessment: AssessmentCreate) -> Tuple[Dict[str, int], List[str]]:
        """Analyze assessment results and generate skill breakdown and recommendations."""
        skill_breakdown = self._calculate_skill_breakdown(assessment.questions)
        recommendations = self._generate_recommendations(skill_breakdown, assessment.subject)
        return skill_breakdown, recommendations

    def _calculate_skill_breakdown(self, questions: List[Question]) -> Dict[str, int]:
        """Calculate skill breakdown from assessment questions."""
        skill_scores = {}
        skill_counts = {}
        
        for question in questions:
            skill = question.skill_category
            weight = self.skill_weights.get(skill, 1.0)
            
            if skill not in skill_scores:
                skill_scores[skill] = 0
                skill_counts[skill] = 0
            
            skill_scores[skill] += weight
            skill_counts[skill] += 1
        
        # Normalize scores
        skill_breakdown = {}
        for skill in skill_scores:
            skill_breakdown[skill] = int((skill_scores[skill] / skill_counts[skill]) * 10)
        
        return skill_breakdown

    def _generate_recommendations(self, skill_breakdown: Dict[str, int], subject: Subject) -> List[str]:
        """Generate personalized recommendations based on skill breakdown."""
        recommendations = []
        
        # Overall performance recommendations
        avg_score = np.mean(list(skill_breakdown.values()))
        if avg_score < 5:
            recommendations.append("Focus on strengthening fundamental concepts")
            recommendations.append("Consider additional support in core areas")
        elif avg_score < 7:
            recommendations.append("Continue practicing to maintain current level")
            recommendations.append("Challenge yourself with more advanced problems")
        else:
            recommendations.append("Excellent work! Keep up the good performance")
            recommendations.append("Consider exploring advanced topics")
        
        # Subject-specific recommendations
        subject_recommendations = self._get_subject_recommendations(subject, skill_breakdown)
        recommendations.extend(subject_recommendations)
        
        # Skill-specific recommendations
        for skill, score in skill_breakdown.items():
            if score < 6:
                recommendations.append(f"Focus on improving {skill} skills")
                recommendations.append(f"Practice more {skill} exercises")
        
        return list(set(recommendations))  # Remove duplicates

    def _get_subject_recommendations(self, subject: Subject, skill_breakdown: Dict[str, int]) -> List[str]:
        """Generate subject-specific recommendations."""
        recommendations = []
        
        if subject == Subject.MATHEMATICS:
            if "Number Operations" in skill_breakdown and skill_breakdown["Number Operations"] < 7:
                recommendations.append("Practice basic arithmetic operations")
            if "Pattern and Function" in skill_breakdown and skill_breakdown["Pattern and Function"] < 7:
                recommendations.append("Work on identifying patterns and sequences")
        
        elif subject == Subject.ENGLISH:
            if "Reading" in skill_breakdown and skill_breakdown["Reading"] < 7:
                recommendations.append("Read more age-appropriate books")
            if "Writing" in skill_breakdown and skill_breakdown["Writing"] < 7:
                recommendations.append("Practice writing short stories and essays")
        
        elif subject == Subject.SCIENCE:
            if "Living Things" in skill_breakdown and skill_breakdown["Living Things"] < 7:
                recommendations.append("Study basic biology concepts")
            if "Forces and Energy" in skill_breakdown and skill_breakdown["Forces and Energy"] < 7:
                recommendations.append("Learn about basic physics principles")
        
        return recommendations

    def cluster_students(self, assessments: List[AssessmentCreate], n_clusters: int = 3) -> Dict[int, List[int]]:
        """Cluster students based on their assessment performance."""
        # Extract features for clustering
        features = []
        student_ids = []
        
        for assessment in assessments:
            skill_scores = list(self._calculate_skill_breakdown(assessment.questions).values())
            features.append(skill_scores)
            student_ids.append(assessment.student_id)
        
        # Perform clustering
        kmeans = KMeans(n_clusters=n_clusters, random_state=42)
        clusters = kmeans.fit_predict(features)
        
        # Organize results
        cluster_results = {i: [] for i in range(n_clusters)}
        for student_id, cluster_id in zip(student_ids, clusters):
            cluster_results[cluster_id].append(student_id)
        
        return cluster_results

    def predict_learning_style(self, assessment: AssessmentCreate) -> str:
        """Predict student's learning style based on assessment performance."""
        skill_breakdown = self._calculate_skill_breakdown(assessment.questions)
        
        # Calculate scores for different learning styles
        visual_score = np.mean([
            skill_breakdown.get("Viewing", 0),
            skill_breakdown.get("Visual Arts", 0)
        ])
        
        auditory_score = np.mean([
            skill_breakdown.get("Listening", 0),
            skill_breakdown.get("Music", 0)
        ])
        
        kinesthetic_score = np.mean([
            skill_breakdown.get("Drama", 0),
            skill_breakdown.get("Dance", 0)
        ])
        
        # Determine dominant learning style
        scores = {
            "Visual": visual_score,
            "Auditory": auditory_score,
            "Kinesthetic": kinesthetic_score
        }
        
        return max(scores.items(), key=lambda x: x[1])[0]

    def calculate_mastery_level(self, score: int) -> MasteryLevel:
        """Calculate mastery level based on assessment score."""
        if score < 4:
            return MasteryLevel.BEGINNER
        elif score < 7:
            return MasteryLevel.DEVELOPING
        elif score < 9:
            return MasteryLevel.PROFICIENT
        else:
            return MasteryLevel.ADVANCED 