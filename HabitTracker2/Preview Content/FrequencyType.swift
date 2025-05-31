
import Foundation

enum FrequencyType: String, Codable, CaseIterable, Identifiable {
    case daily
    case weekly
    case monthly

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .daily: return "Dagligen"
        case .weekly: return "Veckovis"
        case .monthly: return "Månadsvis"
        }
    }
}


