import Foundation
class TaskManager: ObservableObject {
    @Published var tasks: [Tasks] = [] {
        didSet {
            saveTasks()
        }
    }

    private let key = "saved_tasks"

    init() {
        loadTasks()
    }

    func add(task: Tasks) {
        tasks.append(task)
    }

    func saveTasks() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func loadTasks() {
        if let savedData = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([Tasks].self, from: savedData) {
                self.tasks = loaded
            }
        }
    }
}
