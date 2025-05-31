
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
                   IntroductionScreenView(
                       title: "Välkommen!",
                       description: "Skapa vanor som formar ditt liv.",
                       imageName: "healthyHabbit",
                       isLastPage: false
                   )

                   IntroductionScreenView(
                       title: "Små steg ger stora resultat",
                       description: "Att vara konsekvent är nyckeln till framgång.",
                       imageName: "canDoIt",
                       isLastPage: true
                   )
               }
               .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .tabViewStyle(PageTabViewStyle())
    }
}
