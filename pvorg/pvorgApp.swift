import SwiftUI

@main
struct pvorgApp: App {
    @StateObject private var rpsConfig = RpsDataViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(rpsConfig)
        }
    }
}
