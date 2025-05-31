import SwiftUI

struct MonthlyView: View {
    @State private var currentDate = Date()
    @State private var count: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text(getMonthYear())
                .font(.title)
                .bold()

            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 8) {
                ForEach(weekDays, id: \.self) { day in
                    Text(day.prefix(2))
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }

                ForEach(getCalendarDays(), id: \.self) { date in
                    DateView(
                        day: date,
                        isCurrentMonth: isCurrentMonth(day: date),
                        isToday: Calendar.current.isDateInToday(date)
                    )
                }
            }

            TextField("Hur många månader vill du arbeta med denna vana?", text: $count)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 10)
        }
        .padding(.horizontal)
    }

    private func getMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }

    private func getCalendarDays() -> [Date] {
        let calendar = Calendar.current
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let weekdayOffset = calendar.component(.weekday, from: firstOfMonth) - calendar.firstWeekday
        let startDate = calendar.date(byAdding: .day, value: -weekdayOffset, to: firstOfMonth)!
        let endDate = calendar.date(byAdding: .day, value: 41, to: startDate)!

        return calendar.generateDates(inside: startDate...endDate, matching: DateComponents(hour: 0)) ?? []
    }

    private func isCurrentMonth(day: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.component(.month, from: day) == calendar.component(.month, from: currentDate)
    }

    private var weekDays: [String] {
        Calendar.current.shortWeekdaySymbols
    }
}

struct DateView: View {
    let day: Date
    let isCurrentMonth: Bool
    let isToday: Bool
    @State private var isSelected: Bool = false

    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text("\(Calendar.current.component(.day, from: day))")
                .frame(width: 32, height: 32)
                .background(
                    isCurrentMonth
                        ? (isSelected ? Color.yellow : Color.white)
                        : Color.gray.opacity(0.2)
                )
                .foregroundColor(isToday ? .red : .blue)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

extension Calendar {
    func generateDates(inside interval: ClosedRange<Date>, matching components: DateComponents) -> [Date]? {
        var dates: [Date] = []
        enumerateDates(startingAfter: interval.lowerBound, matching: components, matchingPolicy: .nextTime) { date, _, stop in
            if let date = date, date <= interval.upperBound {
                dates.append(date)
            } else {
                stop = true
            }
        }
        return dates
    }
}
