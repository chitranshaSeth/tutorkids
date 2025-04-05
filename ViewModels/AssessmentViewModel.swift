import Foundation
import Combine

class AssessmentViewModel: ObservableObject {
    @Published var currentQuestion: Question
    @Published var results: AssessmentResult
    @Published var questions: [Question]
    @Published var answers: [Int] = []
    private var currentSubject: Subject?
    
    init() {
        // Initialize with a dummy question
        self.currentQuestion = Question(
            text: "Loading...",
            options: [],
            correctAnswer: 0,
            explanation: "",
            difficulty: .beginner,
            skillCategory: ""
        )
        self.results = AssessmentResult(
            subject: .mathematics,
            score: 0,
            totalQuestions: 0,
            completedDate: Date(),
            skillBreakdown: [:],
            recommendations: []
        )
        self.questions = []
        loadSampleQuestions()
    }
    
    private func loadSampleQuestions() {
        questions = [
            // Mathematics Questions
            Question(
                text: "What is the sum of 345 and 267?",
                options: ["612", "622", "632", "642"],
                correctAnswer: 0,
                explanation: "To add 345 and 267, add the ones, tens, and hundreds places separately.",
                difficulty: .intermediate,
                skillCategory: "Number Operations"
            ),
            Question(
                text: "If a rectangle has a length of 8 units and a width of 5 units, what is its area?",
                options: ["13 square units", "26 square units", "40 square units", "45 square units"],
                correctAnswer: 2,
                explanation: "Area of a rectangle = length × width = 8 × 5 = 40 square units",
                difficulty: .intermediate,
                skillCategory: "Geometry"
            ),
            Question(
                text: "What is 1/4 of 24?",
                options: ["4", "6", "8", "12"],
                correctAnswer: 1,
                explanation: "To find 1/4 of 24, divide 24 by 4: 24 ÷ 4 = 6",
                difficulty: .beginner,
                skillCategory: "Fractions"
            ),
            
            // English Questions
            Question(
                text: "Which word is a synonym for 'happy'?",
                options: ["sad", "joyful", "angry", "tired"],
                correctAnswer: 1,
                explanation: "Joyful means the same as happy - feeling or showing great pleasure.",
                difficulty: .beginner,
                skillCategory: "Vocabulary"
            ),
            Question(
                text: "Choose the correct spelling:",
                options: ["recieve", "receive", "recive", "recieive"],
                correctAnswer: 1,
                explanation: "The correct spelling is 'receive' - 'i' before 'e' except after 'c'",
                difficulty: .intermediate,
                skillCategory: "Spelling"
            ),
            Question(
                text: "Which sentence uses the correct punctuation?",
                options: [
                    "The cat sat on the mat.",
                    "The cat sat on the mat!",
                    "The cat sat on the mat?",
                    "The cat sat on the mat,"
                ],
                correctAnswer: 0,
                explanation: "A simple statement should end with a period.",
                difficulty: .beginner,
                skillCategory: "Grammar"
            ),
            
            // Science Questions
            Question(
                text: "Which of these is a renewable energy source?",
                options: ["Coal", "Oil", "Solar power", "Natural gas"],
                correctAnswer: 2,
                explanation: "Solar power is renewable because the sun's energy will continue to be available.",
                difficulty: .intermediate,
                skillCategory: "Energy"
            ),
            Question(
                text: "What is the main function of leaves in plants?",
                options: [
                    "To absorb water",
                    "To make food through photosynthesis",
                    "To support the plant",
                    "To store food"
                ],
                correctAnswer: 1,
                explanation: "Leaves contain chlorophyll which helps plants make their own food through photosynthesis.",
                difficulty: .intermediate,
                skillCategory: "Biology"
            ),
            Question(
                text: "Which planet is known as the Red Planet?",
                options: ["Venus", "Mars", "Jupiter", "Saturn"],
                correctAnswer: 1,
                explanation: "Mars is called the Red Planet because of its reddish appearance due to iron oxide on its surface.",
                difficulty: .beginner,
                skillCategory: "Astronomy"
            ),
            
            // Social Studies Questions
            Question(
                text: "What is the capital of France?",
                options: ["London", "Berlin", "Paris", "Madrid"],
                correctAnswer: 2,
                explanation: "Paris is the capital city of France.",
                difficulty: .beginner,
                skillCategory: "Geography"
            ),
            Question(
                text: "Which ancient civilization built the pyramids?",
                options: ["Romans", "Greeks", "Egyptians", "Mayans"],
                correctAnswer: 2,
                explanation: "The ancient Egyptians built the pyramids as tombs for their pharaohs.",
                difficulty: .intermediate,
                skillCategory: "History"
            ),
            Question(
                text: "What is the main purpose of a map's legend?",
                options: [
                    "To show directions",
                    "To explain symbols and colors used on the map",
                    "To measure distances",
                    "To show the map's scale"
                ],
                correctAnswer: 1,
                explanation: "A map's legend explains what the symbols and colors on the map represent.",
                difficulty: .beginner,
                skillCategory: "Map Skills"
            )
        ]
    }
    
    func startAssessment(for subject: Subject) {
        currentSubject = subject
        questions = generateQuestions(for: subject)
        currentQuestion = questions[0]
        answers = []
    }
    
    func submitAnswer(_ answer: Int) {
        answers.append(answer)
        
        if answers.count < questions.count {
            currentQuestion = questions[answers.count]
        } else {
            generateResults()
        }
    }
    
    private func generateQuestions(for subject: Subject) -> [Question] {
        // This would typically fetch from a backend or local database
        // For now, we'll generate sample questions
        var questions: [Question] = []
        
        switch subject {
        case .mathematics:
            questions = [
                Question(
                    text: "What is 24 ÷ 3?",
                    options: ["6", "7", "8", "9"],
                    correctAnswer: 0,
                    explanation: "24 divided by 3 equals 8",
                    difficulty: .beginner,
                    skillCategory: "Number Operations"
                ),
                // Add more math questions...
            ]
        case .english:
            questions = [
                Question(
                    text: "Which word is a synonym for 'happy'?",
                    options: ["sad", "joyful", "angry", "tired"],
                    correctAnswer: 1,
                    explanation: "Joyful means the same as happy",
                    difficulty: .beginner,
                    skillCategory: "Vocabulary"
                ),
                // Add more English questions...
            ]
        // Add cases for other subjects...
        default:
            break
        }
        
        return questions.shuffled()
    }
    
    private func generateResults() {
        guard let subject = currentSubject else { return }
        
        var score = 0
        var skillBreakdown: [String: Int] = [:]
        
        for (index, question) in questions.enumerated() {
            if answers[index] == question.correctAnswer {
                score += 1
                skillBreakdown[question.skillCategory, default: 0] += 1
            }
        }
        
        let recommendations = generateRecommendations(
            score: score,
            totalQuestions: questions.count,
            skillBreakdown: skillBreakdown
        )
        
        results = AssessmentResult(
            subject: subject,
            score: score,
            totalQuestions: questions.count,
            completedDate: Date(),
            skillBreakdown: skillBreakdown,
            recommendations: recommendations
        )
    }
    
    private func generateRecommendations(
        score: Int,
        totalQuestions: Int,
        skillBreakdown: [String: Int]
    ) -> [String] {
        var recommendations: [String] = []
        let percentage = Double(score) / Double(totalQuestions) * 100
        
        if percentage < 70 {
            recommendations.append("Focus on strengthening fundamental concepts")
            recommendations.append("Practice more problems in areas of weakness")
        } else if percentage < 90 {
            recommendations.append("Continue practicing to maintain current level")
            recommendations.append("Challenge yourself with more advanced problems")
        } else {
            recommendations.append("Excellent work! Keep up the good performance")
            recommendations.append("Consider exploring advanced topics in this subject")
        }
        
        // Add subject-specific recommendations based on skill breakdown
        for (skill, score) in skillBreakdown {
            if Double(score) / Double(totalQuestions) < 0.7 {
                recommendations.append("Focus on improving \(skill) skills")
            }
        }
        
        return recommendations
    }
    
    func recordAnswer(_ questionIndex: Int, _ answer: Int) {
        if answers.count <= questionIndex {
            answers.append(answer)
        } else {
            answers[questionIndex] = answer
        }
    }
    
    func calculateResults() -> AssessmentResult {
        var score = 0
        var skillBreakdown: [String: Int] = [:]
        
        for (index, question) in questions.enumerated() {
            if index < answers.count && answers[index] == question.correctAnswer {
                score += 1
                skillBreakdown[question.skillCategory, default: 0] += 1
            }
        }
        
        let recommendations = generateRecommendations(score: score, skillBreakdown: skillBreakdown)
        
        return AssessmentResult(
            subject: .mathematics, // This should be passed from the question view
            score: score,
            totalQuestions: questions.count,
            completedDate: Date(),
            skillBreakdown: skillBreakdown,
            recommendations: recommendations
        )
    }
} 