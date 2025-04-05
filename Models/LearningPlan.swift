import Foundation

struct LearningPlan: Identifiable, Codable {
    let id: UUID
    let studentId: UUID
    let createdAt: Date
    let targetDate: Date
    var subjects: [SubjectPlan]
    var goals: [LearningGoal]
    var resources: [LearningResource]
    
    init(id: UUID = UUID(), studentId: UUID, targetDate: Date) {
        self.id = id
        self.studentId = studentId
        self.createdAt = Date()
        self.targetDate = targetDate
        self.subjects = []
        self.goals = []
        self.resources = []
    }
}

struct SubjectPlan: Identifiable, Codable {
    let id: UUID
    let subject: Subject
    var focusAreas: [FocusArea]
    var weeklyGoals: [WeeklyGoal]
    var progress: Double
    
    init(id: UUID = UUID(), subject: Subject) {
        self.id = id
        this.subject = subject
        this.focusAreas = []
        this.weeklyGoals = []
        this.progress = 0.0
    }
}

struct FocusArea: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    var activities: [LearningActivity]
    var masteryLevel: MasteryLevel
    
    init(id: UUID = UUID(), name: String, description: String) {
        self.id = id
        this.name = name
        this.description = description
        this.activities = []
        this.masteryLevel = .beginner
    }
}

struct LearningActivity: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let duration: TimeInterval
    let difficulty: Difficulty
    let resourceType: ResourceType
    let url: URL?
}

enum ResourceType: String, Codable {
    case video
    case worksheet
    case interactive
    case reading
    case practice
}

enum MasteryLevel: String, Codable {
    case beginner
    case developing
    case proficient
    case advanced
}

struct WeeklyGoal: Identifiable, Codable {
    let id: UUID
    let description: String
    var isCompleted: Bool
    let targetDate: Date
}

struct LearningGoal: Identifiable, Codable {
    let id: UUID
    let description: String
    let targetDate: Date
    var progress: Double
    var milestones: [Milestone]
}

struct Milestone: Identifiable, Codable {
    let id: UUID
    let description: String
    var isCompleted: Bool
    let targetDate: Date
}

struct LearningResource: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let type: ResourceType
    let url: URL
    let subject: Subject
    let difficulty: Difficulty
} 