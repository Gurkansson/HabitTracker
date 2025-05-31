
import Foundation

struct TasksData {

    static var tasks: [Tasks] = [
        Tasks(name: "Test Habit", frequencyType: .daily, frequency: 1, duration: 4, imageName: "exercise")
    ]

    static var images: [String] = ["exercise", "water", "stop", "sleep", "started"]
}
