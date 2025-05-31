import SwiftUI

struct LandingScreen: View {
    @StateObject private var taskManager = TaskManager()
    @State private var showTaskCreation = false

    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)

    var body: some View {
        ZStack {
            LinearGradient(colors: [.teal, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Text("Mina Vanor")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        showTaskCreation = true
                    } label: {
                        Label("Ny Vana", systemImage: "plus")
                            .padding(10)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(taskManager.tasks.indices, id: \.self) { index in
                            TaskCard(task: taskManager.tasks[index]) {
                                taskManager.tasks.remove(at: index)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showTaskCreation) {
            TaskCreationView(displayTaskCreationView: $showTaskCreation, taskManager: taskManager)
        }
    }
}
