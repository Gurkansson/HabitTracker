//
//  ContentView.swift
//  HabitTracker2
//
//  Created by Frida on 2024-05-08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // My introduction screens
            IntroductionScreenView(title: "Welcome", description: "Welcome to an App that shapes your habits!", imageName: "healthyHabbit", isLastPage: false)
            
            IntroductionScreenView(title: "Gain Success using Consistency", description: "Consistent habits are powerful tools for achieving long-term goals", imageName: "canDoIt", isLastPage: true)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct IntroductionScreenView: View {
    let title: String
    let description: String
    let imageName: String
    let isLastPage: Bool
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if isLastPage {
                Button(action: {
                    isSheetPresented = true
                }) {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .shadow(color:Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.top, 100)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isSheetPresented, content: {
            LandingScreen()
        })
    }
}
