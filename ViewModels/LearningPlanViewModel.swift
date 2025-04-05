import Foundation
import Combine

class LearningPlanViewModel: ObservableObject {
    @Published var learningPlans: [LearningPlan] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSampleLearningPlans()
    }
    
    private func loadSampleLearningPlans() {
        // Mathematics Learning Plan
        let mathPlan = LearningPlan(
            subject: .mathematics,
            focusAreas: [
                FocusArea(
                    name: "Number Operations",
                    masteryLevel: .developing,
                    activities: [
                        LearningActivity(
                            title: "Addition and Subtraction Practice",
                            description: "Practice adding and subtracting numbers up to 1000",
                            duration: 30,
                            resourceType: .interactive
                        ),
                        LearningActivity(
                            title: "Multiplication Tables",
                            description: "Learn multiplication tables from 1 to 12",
                            duration: 45,
                            resourceType: .video
                        )
                    ]
                ),
                FocusArea(
                    name: "Fractions",
                    masteryLevel: .beginner,
                    activities: [
                        LearningActivity(
                            title: "Understanding Fractions",
                            description: "Learn about numerators, denominators, and equivalent fractions",
                            duration: 40,
                            resourceType: .interactive
                        ),
                        LearningActivity(
                            title: "Fraction Operations",
                            description: "Practice adding and subtracting fractions with same denominators",
                            duration: 35,
                            resourceType: .worksheet
                        )
                    ]
                ),
                FocusArea(
                    name: "Geometry",
                    masteryLevel: .intermediate,
                    activities: [
                        LearningActivity(
                            title: "Shapes and Angles",
                            description: "Learn about different shapes and their properties",
                            duration: 25,
                            resourceType: .interactive
                        ),
                        LearningActivity(
                            title: "Area and Perimeter",
                            description: "Calculate area and perimeter of rectangles and squares",
                            duration: 30,
                            resourceType: .worksheet
                        )
                    ]
                )
            ],
            weeklyGoals: [
                WeeklyGoal(
                    title: "Master Basic Operations",
                    description: "Complete all addition and subtraction exercises",
                    isCompleted: false
                ),
                WeeklyGoal(
                    title: "Learn Fractions",
                    description: "Understand basic fractions and complete practice exercises",
                    isCompleted: false
                )
            ],
            progress: 0.4
        )
        
        // English Learning Plan
        let englishPlan = LearningPlan(
            subject: .english,
            focusAreas: [
                FocusArea(
                    name: "Reading Comprehension",
                    masteryLevel: .intermediate,
                    activities: [
                        LearningActivity(
                            title: "Main Idea Practice",
                            description: "Identify main ideas and supporting details in passages",
                            duration: 25,
                            resourceType: .interactive
                        ),
                        LearningActivity(
                            title: "Reading Strategies",
                            description: "Learn and practice different reading strategies",
                            duration: 30,
                            resourceType: .video
                        )
                    ]
                ),
                FocusArea(
                    name: "Grammar",
                    masteryLevel: .developing,
                    activities: [
                        LearningActivity(
                            title: "Parts of Speech",
                            description: "Learn about nouns, verbs, adjectives, and adverbs",
                            duration: 35,
                            resourceType: .interactive
                        ),
                        LearningActivity(
                            title: "Sentence Structure",
                            description: "Practice building complete sentences",
                            duration: 30,
                            resourceType: .worksheet
                        )
                    ]
                ),
                FocusArea(
                    name: "Vocabulary",
                    masteryLevel: .beginner,
                    activities: [
                        LearningActivity(
                            title: "Word Families",
                            description: "Learn about word families and patterns",
                            duration: 25,
                            resourceType: .interactive
                        ),
                        LearningActivity(
                            title: "Context Clues",
                            description: "Use context clues to understand new words",
                            duration: 30,
                            resourceType: .worksheet
                        )
                    ]
                )
            ],
            weeklyGoals: [
                WeeklyGoal(
                    title: "Reading Practice",
                    description: "Read and comprehend grade-level texts",
                    isCompleted: false
                ),
                WeeklyGoal(
                    title: "Grammar Exercises",
                    description: "Complete grammar practice worksheets",
                    isCompleted: false
                )
            ],
            progress: 0.3
        )
        
        // Science Learning Plan
        let sciencePlan = LearningPlan(
            subject: .science,
            focusAreas: [
                FocusArea(
                    name: "Life Science",
                    masteryLevel: .intermediate,
                    activities: [
                        LearningActivity(
                            title: "Plant Life Cycle",
                            description: "Learn about how plants grow and reproduce",
                            duration: 35,
                            resourceType: .interactive
                        ),
                        LearningActivity(
                            title: "Animal Habitats",
                            description: "Explore different animal habitats and adaptations",
                            duration: 40,
                            resourceType: .video
                        )
                    ]
                ),
                FocusArea(
                    name: "Physical Science",
                    masteryLevel: .developing,
                    activities: [
                        LearningActivity(
                            title: "States of Matter",
                            description: "Learn about solid, liquid, and gas",
                            duration: 30,
                            resourceType: .interactive
                        ),
                        LearningActivity(
                            title: "Simple Machines",
                            description: "Explore different types of simple machines",
                            duration: 35,
                            resourceType: .worksheet
                        )
                    ]
                ),
                FocusArea(
                    name: "Earth Science",
                    masteryLevel: .beginner,
                    activities: [
                        LearningActivity(
                            title: "Solar System",
                            description: "Learn about planets and their characteristics",
                            duration: 40,
                            resourceType: .interactive
                        ),
                        LearningActivity(
                            title: "Weather Patterns",
                            description: "Understand basic weather patterns and climate",
                            duration: 35,
                            resourceType: .video
                        )
                    ]
                )
            ],
            weeklyGoals: [
                WeeklyGoal(
                    title: "Science Experiments",
                    description: "Complete hands-on science experiments",
                    isCompleted: false
                ),
                WeeklyGoal(
                    title: "Nature Observation",
                    description: "Observe and record natural phenomena",
                    isCompleted: false
                )
            ],
            progress: 0.25
        )
        
        learningPlans = [mathPlan, englishPlan, sciencePlan]
    }
    
    func getLearningPlan(for subject: Subject) -> LearningPlan? {
        return learningPlans.first { $0.subject == subject }
    }
    
    func updateProgress(for subject: Subject, progress: Double) {
        if let index = learningPlans.firstIndex(where: { $0.subject == subject }) {
            learningPlans[index].progress = progress
        }
    }
    
    func addWeeklyGoal(to subject: Subject, goal: WeeklyGoal) {
        if let index = learningPlans.firstIndex(where: { $0.subject == subject }) {
            learningPlans[index].weeklyGoals.append(goal)
        }
    }
    
    func markGoalAsCompleted(subject: Subject, goalId: UUID) {
        if let planIndex = learningPlans.firstIndex(where: { $0.subject == subject }),
           let goalIndex = learningPlans[planIndex].weeklyGoals.firstIndex(where: { $0.id == goalId }) {
            learningPlans[planIndex].weeklyGoals[goalIndex].isCompleted = true
        }
    }
} 