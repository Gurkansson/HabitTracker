
import SwiftUI

struct ProgressBar: View {
    var finalProgress: Double
    var imageName: String
    var name: String

    var body: some View {
        VStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)

            Text(name)
                .font(.headline)
                .foregroundColor(.white)

            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 10)
                    .foregroundColor(Color.white.opacity(0.2))

                Capsule()
                    .frame(width: CGFloat(finalProgress) * 100, height: 10)
                    .foregroundColor(Theme.primaryColor)
                    .animation(.easeInOut(duration: 0.5), value: finalProgress)
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(16)
        .shadow(radius: 3)
    }
}
