

import SwiftUI

struct WeeklyCountView: View {
    @Binding var duration: String

       var body: some View {
           VStack(alignment: .leading) {
               Text("Hur många veckor vill du jobba med denna vana?")
                   .font(.subheadline)
                   .bold()

               TextField("t.ex. 4", text: $duration)
                   .keyboardType(.numberPad)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
           }
           .padding(.horizontal)
       }
   }
