//
//  LandingScreen.swift
//  HabitTracker2
//
//  Created by Frida on 2024-05-08.
//

import SwiftUI

struct ProgressBar: View {
    @State var progress: Double = 0
    var finalProgress: Double
    var imageName: String
    var name: String
   // var total : Int
   // var completed : Int
    //var durationName : String
    
    
    var body: some View {
        VStack {
            ZStack {
                VStack{
                Image(imageName)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white)
                    
                   /* Text("Completed\(completed)of \(total) \n \(durationName) task")
                        .foregroundColor(.white)
                        .font(.system(size: 9))
                        .multilineTextAlignment(.center)*/
                }
                
                Circle()
                    .stroke(Color.gray, lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(min(1, progress)))
                    .stroke(AngularGradient(gradient: Gradient(colors: [.white]), center: .center
                        ,startAngle: .degrees(0), endAngle: .degrees(360 * progress)), lineWidth: 10)
                    .rotationEffect(.degrees(-90))
            }
            Text(name)
                .bold()
                .foregroundStyle(.white)
        }
        .padding()
        .frame(width: 150, height: 200)
        .onAppear {
            updateProgress(progress: finalProgress)
        }
    }
    
    func updateProgress(progress: Double) {
        withAnimation(.easeInOut(duration: 2.0)) {
            self.progress = progress
        }
    }
}

struct LandingScreen: View {
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    @State var tasks : [Tasks] = TasksData.tasks
    @State var isPresentingFullScreen: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(tasks.indices, id: \.self) { index in
                    ProgressBar(finalProgress: tasks[index].progress,
                                imageName: tasks[index].imageName,
                                name: tasks[index].name)
                    
                    // total: tasks[index].totalDays,
                    //completed: tasks[index].totalDaysCompleted,
                    // durationName: tasks[index].frequencyType.rawValue)
                }
                Button(action: {
                    isPresentingFullScreen = true
                }) {
                    VStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 150)
                            .foregroundColor(Color.white)
                        Text("Add new Task")
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
            }
    
            .background(Gradient(colors: [.teal, .cyan, .green]).opacity(0.8))
            .fullScreenCover(isPresented: $isPresentingFullScreen, content: {
                TaskCreationView(displayTaskCreationView: $isPresentingFullScreen, tasks: $tasks)
            })
        }
    }
    
}
