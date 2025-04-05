import SwiftUI

struct SubjectDetailView: View {
    let subject: Subject
    @EnvironmentObject var learningPlanViewModel: LearningPlanViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var subjectPlan: SubjectPlan? {
        learningPlanViewModel.subjectPlans[subject]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let plan = subjectPlan {
                        // Subject Overview
                        SubjectOverviewView(subject: subject, plan: plan)
                        
                        // Focus Areas
                        FocusAreasView(focusAreas: plan.focusAreas)
                        
                        // Weekly Goals
                        WeeklyGoalsView(goals: plan.weeklyGoals)
                        
                        // Activities
                        ActivitiesView(activities: plan.focusAreas.flatMap { $0.activities })
                    } else {
                        EmptyStateView()
                    }
                }
                .padding()
            }
            .navigationTitle(subject.rawValue)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SubjectOverviewView: View {
    let subject: Subject
    let plan: SubjectPlan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Overview")
                .font(.title2)
                .bold()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Progress")
                        .font(.headline)
                    Text("\(Int(plan.progress * 100))%")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                CircularProgressView(progress: plan.progress)
                    .frame(width: 80, height: 80)
            }
            
            Divider()
            
            Text("IB Standards")
                .font(.headline)
            
            ForEach(subject.ibStandards, id: \.self) { standard in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(standard)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct FocusAreasView: View {
    let focusAreas: [FocusArea]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Focus Areas")
                .font(.title2)
                .bold()
            
            ForEach(focusAreas) { area in
                FocusAreaCard(area: area)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct FocusAreaCard: View {
    let area: FocusArea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(area.name)
                    .font(.headline)
                
                Spacer()
                
                Text(area.masteryLevel.rawValue.capitalized)
                    .font(.caption)
                    .padding(5)
                    .background(masteryLevelColor.opacity(0.2))
                    .foregroundColor(masteryLevelColor)
                    .cornerRadius(5)
            }
            
            Text(area.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if !area.activities.isEmpty {
                Text("Activities:")
                    .font(.subheadline)
                    .bold()
                
                ForEach(area.activities) { activity in
                    ActivityRow(activity: activity)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    var masteryLevelColor: Color {
        switch area.masteryLevel {
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

struct ActivityRow: View {
    let activity: LearningActivity
    
    var body: some View {
        HStack {
            Image(systemName: activityIcon)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(activity.title)
                    .font(.subheadline)
                
                Text(activity.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(formatDuration(activity.duration))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
    
    var activityIcon: String {
        switch activity.resourceType {
        case .video:
            return "play.circle"
        case .worksheet:
            return "doc.text"
        case .interactive:
            return "hand.tap"
        case .reading:
            return "book"
        case .practice:
            return "pencil"
        }
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
}

struct WeeklyGoalsView: View {
    let goals: [WeeklyGoal]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Weekly Goals")
                .font(.title2)
                .bold()
            
            ForEach(goals) { goal in
                WeeklyGoalCard(goal: goal)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct WeeklyGoalCard: View {
    let goal: WeeklyGoal
    
    var body: some View {
        HStack {
            Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(goal.isCompleted ? .green : .gray)
            
            VStack(alignment: .leading) {
                Text(goal.description)
                    .font(.subheadline)
                
                Text(goal.targetDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct ActivitiesView: View {
    let activities: [LearningActivity]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recommended Activities")
                .font(.title2)
                .bold()
            
            ForEach(activities) { activity in
                ActivityCard(activity: activity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct ActivityCard: View {
    let activity: LearningActivity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: activityIcon)
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(activity.title)
                    .font(.headline)
                
                Spacer()
                
                Text(activity.difficulty.rawValue.capitalized)
                    .font(.caption)
                    .padding(5)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(5)
            }
            
            Text(activity.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Label(formatDuration(activity.duration), systemImage: "clock")
                Spacer()
                Label(activity.resourceType.rawValue.capitalized, systemImage: "doc.text")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    var activityIcon: String {
        switch activity.resourceType {
        case .video:
            return "play.circle.fill"
        case .worksheet:
            return "doc.text.fill"
        case .interactive:
            return "hand.tap.fill"
        case .reading:
            return "book.fill"
        case .practice:
            return "pencil.circle.fill"
        }
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
} 