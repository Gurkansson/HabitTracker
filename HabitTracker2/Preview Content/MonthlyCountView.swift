
import SwiftUI

struct MonthlyCountView: View {
    @Binding var duration: String

        var body: some View {
            VStack(alignment: .leading) {
                Text("Hur många månader vill du jobba med denna vana?")
                    .font(.subheadline)
                    .bold()

                TextField("t.ex. 3", text: $duration)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
        }
    }
