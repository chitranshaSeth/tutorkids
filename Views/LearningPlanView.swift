import SwiftUI

struct LearningPlanView: View {
    @EnvironmentObject var learningPlanViewModel: LearningPlanViewModel
    
    var body: some View {
        NavigationView {
            List(Subject.allCases, id: \.self) { subject in
                NavigationLink(destination: SubjectDetailView(subject: subject)) {
                    SubjectPlanRowView(subject: subject)
                }
            }
            .navigationTitle("Learning Plans")
        }
    }
}

struct SubjectPlanRowView: View {
    let subject: Subject
    @EnvironmentObject var learningPlanViewModel: LearningPlanViewModel
    
    var plan: LearningPlan? {
        learningPlanViewModel.getLearningPlan(for: subject)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(subject.rawValue)
                .font(.headline)
            
            if let plan = plan {
                ProgressView(value: plan.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                
                Text("\(Int(plan.progress * 100))% Complete")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(plan.focusAreas.count) Focus Areas")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("No learning plan available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

struct SubjectDetailView: View {
    let subject: Subject
    @EnvironmentObject var learningPlanViewModel: LearningPlanViewModel
    
    var plan: LearningPlan? {
        learningPlanViewModel.getLearningPlan(for: subject)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let plan = plan {
                    // Progress Section
                    VStack {
                        Text("Overall Progress")
                            .font(.headline)
                        ProgressView(value: plan.progress)
                            .progressViewStyle(LinearProgressViewStyle())
                        Text("\(Int(plan.progress * 100))% Complete")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.1))
                    )
                    
                    // Focus Areas Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Focus Areas")
                            .font(.headline)
                        
                        ForEach(plan.focusAreas) { area in
                            FocusAreaView(focusArea: area)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.1))
                    )
                    
                    // Weekly Goals Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Weekly Goals")
                            .font(.headline)
                        
                        ForEach(plan.weeklyGoals) { goal in
                            WeeklyGoalView(goal: goal)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.1))
                    )
                } else {
                    Text("No learning plan available for \(subject.rawValue)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(subject.rawValue)
    }
}

struct FocusAreaView: View {
    let focusArea: FocusArea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(focusArea.name)
                .font(.headline)
            
            Text(focusArea.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Mastery Level: \(focusArea.masteryLevel.rawValue.capitalized)")
                .font(.subheadline)
                .foregroundColor(masteryLevelColor)
            
            if !focusArea.activities.isEmpty {
                Text("Activities:")
                    .font(.subheadline)
                    .padding(.top, 4)
                
                ForEach(focusArea.activities) { activity in
                    ActivityView(activity: activity)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.05))
        )
    }
    
    private var masteryLevelColor: Color {
        switch focusArea.masteryLevel {
        case .beginner:
            return .red
        case .developing:
            return .orange
        case .proficient:
            return .blue
        case .advanced:
            return .green
        }
    }
}

struct WeeklyGoalView: View {
    let goal: WeeklyGoal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.headline)
                
                Text(goal.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Due: \(goal.dueDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if goal.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

struct ActivityView: View {
    let activity: LearningActivity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.subheadline)
                
                Text(activity.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Duration: \(formatDuration(activity.duration))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: resourceTypeIcon)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
    
    private var resourceTypeIcon: String {
        switch activity.resourceType {
        case .video:
            return "play.circle.fill"
        case .reading:
            return "book.fill"
        case .exercise:
            return "pencil.circle.fill"
        case .quiz:
            return "questionmark.circle.fill"
        case .game:
            return "gamecontroller.fill"
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
} 