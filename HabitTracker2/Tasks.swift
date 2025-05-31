import Foundation

class Tasks: Identifiable, ObservableObject, Codable {
    let id: UUID
    @Published var name: String
    @Published var frequencyType: FrequencyType
    @Published var frequency: Int
    @Published var duration: Int
    @Published var progress: Double
    @Published var imageName: String
    @Published var streak: Int
    @Published var lastCompleted: Date?
    @Published var markedDates: [Date]
    @Published var selectedWeekdays: [Int]

    enum CodingKeys: CodingKey {
        case id, name, frequencyType, frequency, duration, progress, imageName, streak, lastCompleted, markedDates, selectedWeekdays
    }

    init(name: String, frequencyType: FrequencyType, frequency: Int, duration: Int, imageName: String, selectedWeekdays: [Int] = []) {
        self.id = UUID()
        self.name = name
        self.frequencyType = frequencyType
        self.frequency = frequency
        self.duration = duration
        self.imageName = imageName
        self.progress = 0
        self.streak = 0
        self.lastCompleted = nil
        self.markedDates = []
        self.selectedWeekdays = selectedWeekdays
    }

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        frequencyType = try container.decode(FrequencyType.self, forKey: .frequencyType)
        frequency = try container.decode(Int.self, forKey: .frequency)
        duration = try container.decode(Int.self, forKey: .duration)
        progress = try container.decode(Double.self, forKey: .progress)
        imageName = try container.decode(String.self, forKey: .imageName)
        streak = try container.decode(Int.self, forKey: .streak)
        lastCompleted = try container.decodeIfPresent(Date.self, forKey: .lastCompleted)
        markedDates = try container.decode([Date].self, forKey: .markedDates)
        selectedWeekdays = try container.decode([Int].self, forKey: .selectedWeekdays)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(frequencyType, forKey: .frequencyType)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(duration, forKey: .duration)
        try container.encode(progress, forKey: .progress)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(streak, forKey: .streak)
        try container.encodeIfPresent(lastCompleted, forKey: .lastCompleted)
        try container.encode(markedDates, forKey: .markedDates)
        try container.encode(selectedWeekdays, forKey: .selectedWeekdays)
    }

    

    func markCompletedToday() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard !markedDates.contains(today) else { return }
        guard isInActivePeriod() else { return }

        if let last = lastCompleted {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            if last == yesterday {
                streak += 1
            } else {
                streak = 1
            }
        } else {
            streak = 1
        }

        markedDates.append(today)
        lastCompleted = today

        let period = getCurrentPeriodRange()
        let validMarks = markedDates.filter { period.contains($0) }
        let max = frequency * duration
        let capped = min(validMarks.count, max)
        progress = Double(capped) / Double(max)
    }

    func isInActivePeriod() -> Bool {
        guard let first = markedDates.min() else { return true }
        let calendar = Calendar.current
        let now = Date()

        switch frequencyType {
        case .weekly:
            guard let end = calendar.date(byAdding: .weekOfYear, value: duration, to: first) else { return true }
            return now <= end
        case .monthly:
            guard let end = calendar.date(byAdding: .month, value: duration, to: first) else { return true }
            return now <= end
        case .daily:
            return true
        }
    }

    func getCurrentPeriodRange() -> ClosedRange<Date> {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())

        switch frequencyType {
        case .weekly:
            let start = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let end = calendar.date(byAdding: .day, value: 6, to: start)!
            return start...end
        case .monthly:
            let start = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let end = calendar.date(byAdding: .month, value: 1, to: start)!
            return start...calendar.date(byAdding: .day, value: -1, to: end)!
        case .daily:
            return now...now
        }
    }

    var currentProgressText: String {
        let currentPeriod = getCurrentPeriodRange()
        let relevant = markedDates.filter { currentPeriod.contains($0) }
        let maxCount = frequency * duration
        return "\(relevant.count)/\(maxCount)"
    }

    var nextDueDescription: String {
        let calendar = Calendar.current
        let today = Date()

        if frequencyType == .daily {
            return "Idag"
        }

        if frequencyType == .weekly || frequencyType == .monthly {
            return "När som helst"
        }

        if !selectedWeekdays.isEmpty {
            let nextWeekday = selectedWeekdays
                .compactMap { weekday -> (weekday: Int, date: Date)? in
                    var components = calendar.dateComponents([.year, .month, .day], from: today)
                    components.weekday = weekday
                    return calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTime)
                        .map { (weekday, $0) }
                }
                .sorted { $0.date < $1.date }
                .first

            if let next = nextWeekday?.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE"
                return formatter.string(from: next)
            }
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: today)
    }
}
