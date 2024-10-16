import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var isSettingup = true
    @State private var settingUpMessage = ""

    var body: some View {
        if isSettingup {
            VStack {
                Text(settingUpMessage)
                    .font(.title)
                    .padding(20)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
            .onAppear {
                setupDataDirs()
            }
        } else {
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

    func setupDataDirs() {
        isSettingup = true
        DispatchQueue.global(qos: .background).async {
            self.settingUpMessage = "Generating TGPs..."
            generateTgps()

            DispatchQueue.main.async {
                self.isSettingup = false
            }
        }
    }

    func generateTgps() {
        guard let genTgpScriptPath = Bundle.main.path(forResource: "gen_tgp", ofType: "sh") else {
            print("Script not found")
            return
        }

        guard let appConfig = appState.appConfig else {
            print("App Config not initialized")
            return
        }

        let videosPath = appConfig.videosPath
        let imgPath = URL(fileURLWithPath: videosPath).appendingPathComponent("img").path
        if !FileManager.default.fileExists(atPath: imgPath) {
            do {
                try FileManager.default.createDirectory(
                    atPath: imgPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Unable to create image directory \(imgPath): \(error.localizedDescription)")
                exit(3)
            }
        }

        for curIndex in 0..<appState.videos.count {
            self.settingUpMessage = "Generating TGPs... \(curIndex + 1)/\(appState.videos.count)"
            let videoName = appState.videos[curIndex].filename
            let videoPath = URL(fileURLWithPath: videosPath).appendingPathComponent(videoName).path
            let imgName = (videoPath as NSString).lastPathComponent + ".jpg"
            let outputPath = (imgPath as NSString).appendingPathComponent(imgName)
            if FileManager.default.fileExists(atPath: outputPath) {
                print("File \(outputPath) exists, skipping.")
                continue
            }

            let process = Process()
            process.executableURL = URL(fileURLWithPath: genTgpScriptPath)
            process.arguments = [videoPath, imgPath]

            do {
                try process.run()
                process.waitUntilExit()
            } catch {
                print("Failed to run script: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .frame(width: 500, height: 400)
}
