import SwiftUI

@main
struct TutorKidsApp: App {
    @StateObject private var assessmentViewModel = AssessmentViewModel()
    @StateObject private var learningPlanViewModel = LearningPlanViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(assessmentViewModel)
                .environmentObject(learningPlanViewModel)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel
    @EnvironmentObject var learningPlanViewModel: LearningPlanViewModel
    
    var body: some View {
        TabView {
            AssessmentView()
                .tabItem {
                    Label("Assessment", systemImage: "checklist")
                }
            
            LearningPlanView()
                .tabItem {
                    Label("Learning Plan", systemImage: "book.fill")
                }
            
            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

struct AssessmentView: View {
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel
    
    var body: some View {
        NavigationView {
            List(Subject.allCases, id: \.self) { subject in
                NavigationLink(destination: SubjectAssessmentView(subject: subject)) {
                    SubjectRowView(subject: subject)
                }
            }
            .navigationTitle("Assessments")
        }
    }
}

struct SubjectRowView: View {
    let subject: Subject
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(subject.rawValue)
                .font(.headline)
            Text("10 questions • 20 minutes")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct SubjectAssessmentView: View {
    let subject: Subject
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int?
    @State private var showingResults = false
    
    var body: some View {
        VStack {
            if currentQuestionIndex < 10 {
                QuestionView(
                    question: assessmentViewModel.currentQuestion,
                    selectedAnswer: $selectedAnswer,
                    onAnswerSelected: { answer in
                        assessmentViewModel.submitAnswer(answer)
                        if currentQuestionIndex < 9 {
                            currentQuestionIndex += 1
                        } else {
                            showingResults = true
                        }
                    }
                )
            } else {
                AssessmentResultsView(results: assessmentViewModel.results)
            }
        }
        .navigationTitle(subject.rawValue)
        .sheet(isPresented: $showingResults) {
            AssessmentResultsView(results: assessmentViewModel.results)
        }
    }
}

struct QuestionView: View {
    let question: Question
    @Binding var selectedAnswer: Int?
    let onAnswerSelected: (Int) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(question.text)
                    .font(.title2)
                    .padding()
                
                ForEach(question.options.indices, id: \.self) { index in
                    Button(action: {
                        selectedAnswer = index
                        onAnswerSelected(index)
                    }) {
                        HStack {
                            Text(question.options[index])
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedAnswer == index {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedAnswer == index ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct AssessmentResultsView: View {
    let results: AssessmentResult
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Assessment Complete!")
                .font(.title)
                .bold()
            
            Text("Score: \(Int(results.percentageScore))%")
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Skill Breakdown:")
                    .font(.headline)
                
                ForEach(Array(results.skillBreakdown.keys), id: \.self) { skill in
                    HStack {
                        Text(skill)
                        Spacer()
                        Text("\(results.skillBreakdown[skill] ?? 0)/10")
                    }
                }
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Recommendations:")
                    .font(.headline)
                
                ForEach(results.recommendations, id: \.self) { recommendation in
                    Text("• \(recommendation)")
                }
            }
            .padding()
        }
        .padding()
    }
} 