import SwiftUI

struct DaysView: View {
    @Binding var selectedDays: [Int] // Söndag = 1, Måndag = 2, ..., Lördag = 7

    let daysOfWeek = ["Sön", "Mån", "Tis", "Ons", "Tor", "Fre", "Lör"]

    var body: some View {
        VStack(spacing: 15) {
            Text("Välj vilka dagar du vill göra denna vana:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            HStack(spacing: 10) {
                ForEach(1...7, id: \.self) { index in
                    Button(action: {
                        if selectedDays.contains(index) {
                            selectedDays.removeAll { $0 == index }
                        } else {
                            selectedDays.append(index)
                        }
                    }) {
                        Text(daysOfWeek[index - 1])
                            .font(.caption)
                            .frame(width: 40, height: 40)
                            .background(selectedDays.contains(index) ? Color.yellow : Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.accentColor.opacity(0.4), lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
