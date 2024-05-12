//
//  TaskCreationView.swift
//  HabitTracker2
//
//  Created by Frida on 2024-05-08.
//

import SwiftUI

struct TaskCreationView: View {
    @Binding var displayTaskCreationView: Bool
    @Binding var tasks: [Tasks]
    @State private var description: String = ""
    @State private var taskImage: String = "bicycle"
    @State private var selectedOption = FrequencyType.daily
    @State private var displayImageSelectionView = false
    let startDate: Date = Date()
    @State private var settingsDetent = PresentationDetent.medium
    @State private var count: String = ""

  
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    ZStack(alignment: .bottomTrailing) {
                        Image(taskImage)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.white)
                        
                        Button(action: {
                            displayImageSelectionView = true
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.yellow)
                                .frame(width: 25, height: 25)
                                .alignmentGuide(.bottom) { d in
                                    d[.bottom]
                                }
                        }
                    }
                    TextField("Enter details of task", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                .padding(.leading, 20)
                
                Picker("Select an option", selection: $selectedOption){
                    ForEach(FrequencyType.allCases){ freq in
                        Text(freq.rawValue.capitalized)
                            .tag(freq)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedOption == FrequencyType.daily {
                    DaysView()
                } else if selectedOption == FrequencyType.weekly {
                    VStack {
                        HStack(spacing: 5) {
                            ForEach(0..<7) { index in
                                let date = Calendar.current.date(byAdding: .day, value: index, to: startDate)
                                    ?? Date()
                                DayView(date: date)
                            }
                        }
                        TextField("Enter the number of weeks you want to work on this habit", text: $count)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                } else {
                   MonthlyView()
                }
                
                Spacer()
                Button(action: {
                    displayTaskCreationView = false
                    let task = Tasks(name: description, frequencyType: .daily, frequency: 1, progress: 0.1, imageName: taskImage)
                    tasks.append(task)
                }) {
                    Text("Create Task")
                        .frame(width: 300, height: 40)
                        .background(Color.white)
                        .foregroundColor(.purple)
                        .cornerRadius(10)
                }
            }
        }
        .background(Gradient(colors: [.teal, .cyan, .green]).opacity(0.8))
        .sheet(isPresented: $displayImageSelectionView, onDismiss: {}) {
            ImageSelectionView(taskImage: $taskImage, isPresented: $displayImageSelectionView)
                .presentationDetents([.medium, .large], selection: $settingsDetent)
        }
    }
}

struct DayView: View {
    let date: Date
    @State var isSelected = false
    
    var body: some View {
            Button(action: {
                isSelected.toggle()
            }) {
                VStack {
                    Text(dayOfWeekFormatter.string(from: date))
                    Text(dayFormatter.string(from: date))
                }//.foregroundColor(.purple)
                .background(Gradient(colors: [.teal, .cyan, .green]).opacity(0.8))
            }
            .frame(width: 50, height: 80)
            .background(isSelected ? Color.yellow : Color.white)
            .cornerRadius(10)
    }
    
    private let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
}

struct DaysView: View {
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    @State var isSelected = [false, false, false, false, false, false, false]
    @State var count: String = ""
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<daysOfWeek.count) { index in
                Button(action: {
                    isSelected[index].toggle()
                }) {
                    Text(daysOfWeek[index].prefix(2))
                    //.foregroundColor(.blue)
                        .background(Gradient(colors: [.teal, .cyan, .green]).opacity(0.8));
                }.frame(width: 40, height: 40)
                .background(isSelected[index] ? Color.yellow : Color.white)
                .cornerRadius(20)
            }
        }
        .padding()
        TextField("Enter the number of days you want to work on this habit", text: $count)
            .keyboardType(.numberPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}
