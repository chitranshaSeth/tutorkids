import SwiftUI

struct AssessmentResultsView: View {
    let results: AssessmentResult
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Score Section
                VStack {
                    Text("Score")
                        .font(.headline)
                    Text("\(results.score)/\(results.totalQuestions)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(scoreColor)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.1))
                )
                
                // Skill Breakdown Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Skill Breakdown")
                        .font(.headline)
                    
                    ForEach(results.skillBreakdown.sorted(by: { $0.key < $1.key }), id: \.key) { skill, score in
                        HStack {
                            Text(skill)
                            Spacer()
                            Text("\(score)")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.1))
                )
                
                // Recommendations Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recommendations")
                        .font(.headline)
                    
                    ForEach(results.recommendations, id: \.self) { recommendation in
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(recommendation)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.1))
                )
                
                // Done Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationBarTitle("Assessment Results", displayMode: .inline)
    }
    
    private var scoreColor: Color {
        let percentage = Double(results.score) / Double(results.totalQuestions)
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