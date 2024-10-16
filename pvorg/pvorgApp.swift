import SwiftUI

@main
struct pvorgApp: App {
    @StateObject private var rpsData = RpsDataViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(rpsData)
        }
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button(action: toggleDarkMode) {
                    Text("Toggle Dark Mode")
                }
                .keyboardShortcut("D", modifiers: [.command, .shift])
            }
            CommandGroup(after: .appSettings) {
                Button(action: {
                    rpsData.refreshCombinations()
                }) {
                    Text("Shuffle Combinations")
                }
                .keyboardShortcut("S", modifiers: [.command, .shift])
            }
            CommandGroup(after: .appSettings) {
                Button(action: {
                    rpsData.reloadData()
                }) {
                    Text("Refresh data")
                }
                .keyboardShortcut("R", modifiers: [.command, .shift])
            }
        }
    }

    func toggleDarkMode() {
        let currentAppearance = NSApp.effectiveAppearance
        let newAppearance = (currentAppearance.name == .darkAqua) ? NSAppearance.Name.aqua : NSAppearance.Name.darkAqua
        NSApp.appearance = NSAppearance(named: newAppearance)
    }
}
