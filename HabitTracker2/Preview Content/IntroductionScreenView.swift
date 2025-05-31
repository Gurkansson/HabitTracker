
import SwiftUI

struct IntroductionScreenView: View {
    let title: String
    let description: String
    let imageName: String
    let isLastPage: Bool

    @State private var isSheetPresented = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 250)
                .padding()

            Text(title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            if isLastPage {
                Button(action: {
                    isSheetPresented = true
                }) {
                    Text("Kom igång")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                .padding(.top, 40)
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $isSheetPresented) {
            LandingScreen()
        }
    }
}

