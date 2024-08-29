import SwiftUI

@main
struct pvorgApp: App {
    @StateObject private var rpsData = RpsDataViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(rpsData)
        }
    }
}
