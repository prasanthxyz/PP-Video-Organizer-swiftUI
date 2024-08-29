import SwiftUI

struct ContentView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(rpsData.data.getCurrentCombination().galleryName)
            Button(action: {
                rpsData.data.moveToNextCombination()
            }) {
                Text("Click me")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
