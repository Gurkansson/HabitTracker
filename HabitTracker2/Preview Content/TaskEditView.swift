import SwiftUI
struct TaskEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var task: Tasks
    var onDelete: () -> Void

    @State private var editedName: String = ""
    @State private var selectedFrequency: FrequencyType = .daily
    @State private var duration: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Namn")) {
                    TextField("Namn på vanan", text: $editedName)
                }

                Section(header: Text("Frekvens")) {
                    Picker("Typ", selection: $selectedFrequency) {
                        ForEach(FrequencyType.allCases) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    TextField("Hur många \(selectedFrequency == .weekly ? "veckor" : selectedFrequency == .monthly ? "månader" : "dagar")?", text: $duration)
                        .keyboardType(.numberPad)
                }

                Section {
                    Button("Spara ändringar") {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }

                    Button("🗑 Ta bort vana", role: .destructive) {
                        onDelete()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Redigera Vana")
            .onAppear {
                editedName = task.name
                selectedFrequency = task.frequencyType
                duration = String(task.duration)
            }
        }
    }

    func saveChanges() {
        task.name = editedName
        task.frequencyType = selectedFrequency
        task.duration = Int(duration) ?? 1
        task.progress = 0.0
        task.markedDates = []
        task.streak = 0
    }
}
