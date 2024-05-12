//
//  Tasks.swift
//  HabitTracker2
//
//  Created by Frida on 2024-05-08.
//

import Foundation

enum FrequencyType: String, CaseIterable, Identifiable {
    case daily
    case weekly
    case monthly
    
    var id: String { self.rawValue }
}

class Tasks {
    var id: UUID = UUID()
    var name: String
    var frequencyType: FrequencyType
    var frequency: Int
    var progress: Double
    var imageName: String
   // var days: [Int]
   // var totalDays: Int
   // var totalDaysCompleted: Int
    
    init(name: String, frequencyType: FrequencyType, frequency: Int, progress: Double, imageName: String) {
        self.name = name
        self.frequencyType = frequencyType
        self.frequency = frequency
        self.progress = progress
        self.imageName = imageName
      //  self.days = days
        //self.totalDays = 0
      //  self.totalDaysCompleted = 0
    }
    
   // func updateProgress() {
     //   self.totalDaysCompleted = totalDaysCompleted + 1
       // self.progress = Double(totalDaysCompleted) / Double(totalDays)
    //}
}
