//
//  ImageSelectionView.swift
//  HabitTracker2
//
//  Created by Frida on 2024-05-08.
//

import SwiftUI

struct ImageSelectionView: View {
    @Binding var taskImage: String
    @Binding var isPresented: Bool
    
    var body: some View {
        Text("Select an Image")
            .font(.headline)
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2),spacing: 5) {
            ForEach(0..<TasksData.images.count, id: \.self) { index in
                    HabitCellView(index: index, isSelected: TasksData.images[index] == taskImage)
                        .onTapGesture {
                            taskImage = TasksData.images[index]
                            isPresented = false
                        }
                }
            }
        }
    }

struct HabitCellView: View {
    let index: Int
    let isSelected: Bool
    
    var body: some View {
        Image(TasksData.images[index])
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 80)
            .foregroundColor(.white)
    }
}
