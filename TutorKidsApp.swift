import SwiftUI

@main
struct TutorKidsApp: App {
    @StateObject private var assessmentViewModel = AssessmentViewModel()
    @StateObject private var learningPlanViewModel = LearningPlanViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                AssessmentView()
                    .tabItem {
                        Label("Assessment", systemImage: "list.bullet.clipboard")
                    }
                    .environmentObject(assessmentViewModel)
                
                LearningPlanView()
                    .tabItem {
                        Label("Learning Plan", systemImage: "book.fill")
                    }
                    .environmentObject(learningPlanViewModel)
                
                ProgressView()
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
                    .environmentObject(assessmentViewModel)
                    .environmentObject(learningPlanViewModel)
            }
        }
    }
} 