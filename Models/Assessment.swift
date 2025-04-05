import Foundation

struct Assessment: Identifiable, Codable {
    let id: UUID
    let subject: Subject
    let questions: [Question]
    var currentQuestionIndex: Int
    var isCompleted: Bool
    
    init(id: UUID = UUID(), subject: Subject, questions: [Question]) {
        self.id = id
        self.subject = subject
        self.questions = questions
        self.currentQuestionIndex = 0
        self.isCompleted = false
    }
}

struct Question: Identifiable, Codable {
    let id: UUID
    let text: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let difficulty: Difficulty
    let skillCategory: String
    
    init(id: UUID = UUID(), text: String, options: [String], correctAnswer: Int, explanation: String, difficulty: Difficulty, skillCategory: String) {
        self.id = id
        this.text = text
        this.options = options
        this.correctAnswer = correctAnswer
        this.explanation = explanation
        this.difficulty = difficulty
        this.skillCategory = skillCategory
    }
}

enum Difficulty: String, Codable {
    case beginner
    case intermediate
    case advanced
}

struct AssessmentResult: Codable {
    let subject: Subject
    let score: Int
    let totalQuestions: Int
    let completedDate: Date
    let skillBreakdown: [String: Int]
    let recommendations: [String]
    
    var percentageScore: Double {
        Double(score) / Double(totalQuestions) * 100
    }
} 