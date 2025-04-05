import Foundation

enum Subject: String, CaseIterable {
    case mathematics = "Mathematics"
    case english = "English"
    case science = "Science"
    case socialStudies = "Social Studies"
    case arts = "Arts"
}

enum Difficulty: String, Codable {
    case beginner
    case intermediate
    case advanced
}

enum MasteryLevel: String, Codable {
    case beginner
    case developing
    case proficient
    case advanced
}

struct Question: Identifiable, Codable {
    let id: UUID
    let text: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let difficulty: Difficulty
    let skillCategory: String
    
    init(
        id: UUID = UUID(),
        text: String,
        options: [String],
        correctAnswer: Int,
        explanation: String,
        difficulty: Difficulty,
        skillCategory: String
    ) {
        self.id = id
        self.text = text
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.difficulty = difficulty
        self.skillCategory = skillCategory
    }
}

struct AssessmentResult: Codable {
    let subject: Subject
    let score: Int
    let totalQuestions: Int
    let completedDate: Date
    let skillBreakdown: [String: Int]
    let recommendations: [String]
}

struct LearningPlan: Identifiable, Codable {
    let id: UUID
    let studentId: UUID
    let subject: Subject
    let progress: Double
    let focusAreas: [FocusArea]
    let weeklyGoals: [WeeklyGoal]
    let activities: [LearningActivity]
    
    init(
        id: UUID = UUID(),
        studentId: UUID,
        subject: Subject,
        progress: Double = 0.0,
        focusAreas: [FocusArea] = [],
        weeklyGoals: [WeeklyGoal] = [],
        activities: [LearningActivity] = []
    ) {
        self.id = id
        self.studentId = studentId
        self.subject = subject
        self.progress = progress
        self.focusAreas = focusAreas
        self.weeklyGoals = weeklyGoals
        self.activities = activities
    }
}

struct FocusArea: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let masteryLevel: MasteryLevel
    let activities: [LearningActivity]
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        masteryLevel: MasteryLevel,
        activities: [LearningActivity] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.masteryLevel = masteryLevel
        self.activities = activities
    }
}

struct WeeklyGoal: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let isCompleted: Bool
    let dueDate: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        isCompleted: Bool = false,
        dueDate: Date = Date().addingTimeInterval(7 * 24 * 60 * 60)
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}

struct LearningActivity: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let duration: TimeInterval
    let resourceType: ResourceType
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        duration: TimeInterval,
        resourceType: ResourceType
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.duration = duration
        self.resourceType = resourceType
    }
}

enum ResourceType: String, Codable {
    case video
    case reading
    case exercise
    case quiz
    case game
} 