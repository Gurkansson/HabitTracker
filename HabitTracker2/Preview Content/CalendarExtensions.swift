/*import Foundation

extension Calendar {
    func isDate(_ date1: Date, inSamePeriodAs date2: Date, frequencyType: FrequencyType) -> Bool {
        switch frequencyType {
        case .daily:
            return isDate(date1, inSameDayAs: date2)
        case .weekly:
            return component(.weekOfYear, from: date1) == component(.weekOfYear, from: date2) &&
                   component(.yearForWeekOfYear, from: date1) == component(.yearForWeekOfYear, from: date2)
        case .monthly:
            return component(.month, from: date1) == component(.month, from: date2) &&
                   component(.year, from: date1) == component(.year, from: date2)
        }
    }
}
*/
