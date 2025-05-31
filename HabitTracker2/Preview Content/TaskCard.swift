import SwiftUI

struct TaskCard: View {
    @ObservedObject var task: Tasks
    var onDelete: () -> Void
    @State private var showEdit = false

    let calendar = Calendar.current
    let weekdaySymbols = Calendar.current.shortWeekdaySymbols

    var body: some View {
        VStack(spacing: 10) {
            Image(task.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(6)
                .background(Color.white.opacity(0.9))
                .clipShape(Circle())

            Text(scheduleText)
                .font(.subheadline)
                .foregroundColor(.white)

            Text("Nästa gång: \(task.nextDueDescription)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))

            Text(completionText)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))

            ProgressView(value: task.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .frame(width: 100)

            Button("Markera Utförd") {
                task.markCompletedToday()
            }
            .font(.caption)
            .padding(6)
            .background(Color.white.opacity(0.8))
            .foregroundColor(.blue)
            .cornerRadius(8)

            VStack(spacing: 2) {
                Text("🔥 Streak: \(task.streak) dagar")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("✅ Totalt: \(task.markedDates.count) gånger")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }


            Button("Redigera") {
                showEdit = true
            }
            .font(.caption2)
            .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 4)
        .sheet(isPresented: $showEdit) {
            TaskEditView(task: task, onDelete: onDelete)
        }
    }

    private var completionText: String {
        let range = task.getCurrentPeriodRange()
        let doneCount = task.markedDates.filter { range.contains($0) }.count
        let label = task.frequencyType == .weekly ? "denna vecka" : "denna månad"
        return "\(doneCount)/\(task.frequency) \(label)"
    }

    private var scheduleText: String {
        let durationText: String
        switch task.frequencyType {
        case .weekly:
            durationText = "(i \(task.duration) veckor)"
        case .monthly:
            durationText = "(i \(task.duration) månader)"
        default:
            durationText = ""
        }

        if !task.selectedWeekdays.isEmpty {
            let days = task.selectedWeekdays
                .compactMap { weekdaySymbols[safe: $0 - 1] }
                .joined(separator: ", ")
            return "Varje: \(days) \(durationText)"
        } else {
            switch task.frequencyType {
            case .weekly:
                return "\(task.frequency) gång(er) per vecka \(durationText)"
            case .monthly:
                return "\(task.frequency) gång(er) per månad \(durationText)"
            default:
                return "Dagligen"
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
