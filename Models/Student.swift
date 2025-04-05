import Foundation

struct Student: Identifiable, Codable {
    let id: UUID
    var name: String
    var grade: Int
    var age: Int
    var assessmentResults: [Subject: AssessmentResult]
    var learningPlan: LearningPlan?
    
    init(id: UUID = UUID(), name: String, grade: Int, age: Int) {
        self.id = id
        self.name = name
        self.grade = grade
        self.age = age
        self.assessmentResults = [:]
    }
}

enum Subject: String, Codable, CaseIterable {
    case mathematics = "Mathematics"
    case english = "English"
    case science = "Science"
    case socialStudies = "Social Studies"
    case arts = "Arts"
    
    var ibStandards: [String] {
        switch self {
        case .mathematics:
            return ["Number", "Pattern and Function", "Shape and Space", "Data Handling"]
        case .english:
            return ["Reading", "Writing", "Speaking", "Listening", "Viewing", "Presenting"]
        case .science:
            return ["Living Things", "Materials and Matter", "Forces and Energy", "Earth and Space"]
        case .socialStudies:
            return ["Human Systems", "Social Organization", "Culture", "Time, Continuity and Change"]
        case .arts:
            return ["Visual Arts", "Music", "Drama", "Dance"]
        }
    }
} 