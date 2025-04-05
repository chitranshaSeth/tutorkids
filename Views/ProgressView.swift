import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel
    @EnvironmentObject var learningPlanViewModel: LearningPlanViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Overall Progress Section
                    VStack {
                        Text("Overall Progress")
                            .font(.headline)
                        
                        HStack {
                            ForEach(Subject.allCases, id: \.self) { subject in
                                VStack {
                                    CircularProgressView(
                                        progress: learningPlanViewModel.getLearningPlan(for: subject)?.progress ?? 0
                                    )
                                    .frame(width: 60, height: 60)
                                    
                                    Text(subject.rawValue)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.1))
                    )
                    
                    // Recent Assessments Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Assessments")
                            .font(.headline)
                        
                        if let results = assessmentViewModel.results {
                            AssessmentResultCard(result: results)
                        } else {
                            Text("No recent assessments")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.1))
                    )
                    
                    // Learning Style Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Learning Style")
                            .font(.headline)
                        
                        if let results = assessmentViewModel.results {
                            LearningStyleCard(learningStyle: results.learningStyle)
                        } else {
                            Text("Complete an assessment to discover your learning style")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(progressColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .bold()
        }
    }
    
    private var progressColor: Color {
        switch progress {
        case 0..<0.4:
            return .red
        case 0.4..<0.7:
            return .orange
        case 0.7..<0.9:
            return .blue
        default:
            return .green
        }
    }
}

struct AssessmentResultCard: View {
    let result: AssessmentResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(result.subject.rawValue)
                    .font(.headline)
                Spacer()
                Text("\(result.score)/\(result.totalQuestions)")
                    .font(.headline)
                    .foregroundColor(scoreColor)
            }
            
            Text("Completed: \(result.completedDate, style: .date)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if !result.skillBreakdown.isEmpty {
                Text("Top Skills:")
                    .font(.subheadline)
                    .padding(.top, 4)
                
                ForEach(result.skillBreakdown.sorted(by: { $0.value > $1.value }).prefix(3), id: \.key) { skill, score in
                    HStack {
                        Text(skill)
                        Spacer()
                        Text("\(score)")
                            .foregroundColor(.secondary)
                    }
                    .font(.caption)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.05))
        )
    }
    
    private var scoreColor: Color {
        let percentage = Double(result.score) / Double(result.totalQuestions)
        switch percentage {
        case 0..<0.4:
            return .red
        case 0.4..<0.7:
            return .orange
        case 0.7..<0.9:
            return .blue
        default:
            return .green
        }
    }
}

struct LearningStyleCard: View {
    let learningStyle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: learningStyleIcon)
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(learningStyle)
                    .font(.headline)
            }
            
            Text(learningStyleDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.05))
        )
    }
    
    private var learningStyleIcon: String {
        switch learningStyle.lowercased() {
        case "visual":
            return "eye.fill"
        case "auditory":
            return "ear.fill"
        case "kinesthetic":
            return "hand.raised.fill"
        default:
            return "person.fill"
        }
    }
    
    private var learningStyleDescription: String {
        switch learningStyle.lowercased() {
        case "visual":
            return "You learn best through seeing and visual aids"
        case "auditory":
            return "You learn best through listening and verbal communication"
        case "kinesthetic":
            return "You learn best through hands-on activities and movement"
        default:
            return "Complete an assessment to discover your learning style"
        }
    }
} 