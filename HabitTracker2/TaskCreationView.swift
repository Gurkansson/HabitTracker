import SwiftUI
import UserNotifications

struct TaskCreationView: View {
    @Binding var displayTaskCreationView: Bool
    @ObservedObject var taskManager: TaskManager

    @State private var name: String = ""
    @State private var selectedFrequency: FrequencyType = .daily
    @State private var taskImage: String = "exercise"
    @State private var showImagePicker = false

    @State private var weeklyFrequency: String = ""
    @State private var weeklyDuration: String = ""

    @State private var monthlyFrequency: String = ""
    @State private var monthlyDuration: String = ""

    @State private var selectedWeekdays: [Int] = []
    @State private var reminderTime = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Spacer()
                        Button(action: {
                            displayTaskCreationView = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing)
                    }

                    Text("Skapa Ny Vana")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ZStack(alignment: .bottomTrailing) {
                        Image(taskImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())

                        Button {
                            showImagePicker = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.blue)
                        }
                    }

                    TextField("Namn på vanan", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Picker("Frekvens", selection: $selectedFrequency) {
                        ForEach(FrequencyType.allCases) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    if selectedFrequency == .daily {
                        Text("Vilka dagar i veckan?")
                            .font(.subheadline)
                            .bold()
                            .padding(.horizontal)

                        DaysView(selectedDays: $selectedWeekdays)
                    } else if selectedFrequency == .weekly {
                        WeeklyCountView(duration: $weeklyDuration)
                    } else if selectedFrequency == .monthly {
                        MonthlyCountView(duration: $monthlyDuration)
                    }

                    DatePicker("Tid för påminnelse", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .padding(.horizontal)

                    Button {
                        let frequency: Int
                        let duration: Int

                        switch selectedFrequency {
                        case .daily:
                            frequency = selectedWeekdays.count
                            duration = 4
                        case .weekly:
                            frequency = Int(weeklyFrequency) ?? 1
                            duration = Int(weeklyDuration) ?? 1
                        case .monthly:
                            frequency = Int(monthlyFrequency) ?? 1
                            duration = Int(monthlyDuration) ?? 1
                        }

                        let task = Tasks(
                            name: name,
                            frequencyType: selectedFrequency,
                            frequency: frequency,
                            duration: duration,
                            imageName: taskImage,
                            selectedWeekdays: selectedWeekdays
                        )

                        // Schemalägg notiser
                        for day in selectedWeekdays {
                            var components = DateComponents()
                            components.weekday = day
                            components.hour = Calendar.current.component(.hour, from: reminderTime)
                            components.minute = Calendar.current.component(.minute, from: reminderTime)

                            let content = UNMutableNotificationContent()
                            content.title = "Dags att utföra \(name)"
                            content.body = "Din vana väntar på dig!"
                            content.sound = UNNotificationSound.default

                            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request)
                        }

                        taskManager.add(task: task)
                        displayTaskCreationView = false
                    } label: {
                        Text("Skapa Vana")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .disabled(name.isEmpty)
                }
                .padding(.vertical)
            }
            .sheet(isPresented: $showImagePicker) {
                ImageSelectionView(taskImage: $taskImage, isPresented: $showImagePicker)
            }
        }
    }
}
