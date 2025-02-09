//
//  MonthlyView.swift
//  HabitTracker2
//
//  Created by Frida on 2024-05-10.
//

import SwiftUI
struct MonthlyView: View {
    @State private var currentDate = Date()
    @State private var count: String = ""
    
    var body: some View {
        VStack {
            Text(getMonthYear())
                .font(.title)
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                ForEach(0..<weekDays.count) { index in
                    Text(weekDays[index].prefix(2))
                }
                
                ForEach(getCalendarDays(), id: \.self) { day in
                    DateView(day: day, isCurrentMonth: isCurrentMonth(day: day), isToday: false)
                }
            }
            .padding(.horizontal)
            
            TextField("Enter the number of months you want to work on this habit", text: $count)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
    
    private func getMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: currentDate)
    }
    
    private func getCalendarDays() -> [Date] {
        let calendar = Calendar.current
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: currentDate)))!
        let startDate = calendar.date(byAdding: .day, value: -calendar.component(.weekday, from: firstDayOfMonth), to: firstDayOfMonth)!
        let endDate = calendar.date(byAdding: .day, value: 41, to: startDate)!
        
        let firstWeekdayComponents = DateComponents(
            hour: 0,
            minute: 0,
            second: 0,
            nanosecond: 0)
        
        return calendar.generateDates(inside: startDate...endDate, matching: firstWeekdayComponents, matchingPolicy: .nextTime)!
    }
    
    private func isCurrentMonth(day: Date) -> Bool {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: day)
        let month = calendar.component(.month, from: day)
        
        return currentYear == year && currentMonth == month
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
                .frame(width: 40, height: 40)
                .background(isCurrentMonth ? (isSelected ? Color.yellow : Color.white.opacity(0.5)) : (isSelected ? Color.yellow : Color.black.opacity(0.2)))
                .foregroundColor(isToday ? Color.black : Color.blue)
                .cornerRadius(8)
        }
    }
}

extension Calendar {
    func generateDates(inside interval: ClosedRange<Date>, matching component: DateComponents, matchingPolicy: Calendar.MatchingPolicy) -> [Date]? {
        var dates: [Date] = []
        enumerateDates(startingAfter: interval.lowerBound, matching: component, matchingPolicy: matchingPolicy) { date, _, stop in
            if let date = date, date <= interval.upperBound {
                dates.append(date)
            } else {
                stop = true
            }
        }
        return dates.isEmpty ? nil : dates
    }
}

private var weekDays: [String] {
    Calendar.current.shortWeekdaySymbols
}
