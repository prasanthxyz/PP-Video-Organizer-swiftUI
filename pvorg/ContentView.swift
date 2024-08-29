import SwiftUI

struct ContentView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        TabView {
            ViewTabContentView()
                .tabItem {
                    Label("View", systemImage: "list.dash")
                }

            ConfigTabContentView()
                .tabItem {
                    Label("Config", systemImage: "list.dash")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
