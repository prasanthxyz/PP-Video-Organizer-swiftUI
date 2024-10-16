import AVKit
import SwiftUI

struct VideoView: View {
    @EnvironmentObject var appState: AppState

    @State private var player: AVPlayer?
    @State private var isLoading = true

    var body: some View {
        if !appState.combinations.isEmpty {
            VStack {
                if isLoading {
                    Text("Loading...")
                } else if let player = player {
                    VideoPlayer(player: player)
                        .onChange(of: appState.isVideoPlaying) {
                            if appState.isVideoPlaying {
                                player.play()
                            } else {
                                player.pause()
                            }
                        }
                    HStack {
                        Button(action: {
                            appState.isVideoPlaying.toggle()
                        }) {
                            Image(systemName: "play.fill")
                        }
                        .keyboardShortcut(.space, modifiers: [])

                        Button(action: { seek(to: 0.0) }) { Text("0") }.keyboardShortcut("0", modifiers: [])
                        Button(action: { seek(to: 0.1) }) { Text("1") }.keyboardShortcut("1", modifiers: [])
                        Button(action: { seek(to: 0.2) }) { Text("2") }.keyboardShortcut("2", modifiers: [])
                        Button(action: { seek(to: 0.3) }) { Text("3") }.keyboardShortcut("3", modifiers: [])
                        Button(action: { seek(to: 0.4) }) { Text("4") }.keyboardShortcut("4", modifiers: [])
                        Button(action: { seek(to: 0.5) }) { Text("5") }.keyboardShortcut("5", modifiers: [])
                        Button(action: { seek(to: 0.6) }) { Text("6") }.keyboardShortcut("6", modifiers: [])
                        Button(action: { seek(to: 0.7) }) { Text("7") }.keyboardShortcut("7", modifiers: [])
                        Button(action: { seek(to: 0.8) }) { Text("8") }.keyboardShortcut("8", modifiers: [])
                        Button(action: { seek(to: 0.9) }) { Text("9") }.keyboardShortcut("9", modifiers: [])
                        Button(action: { seekLeft() }) { Text("left") }.keyboardShortcut(.leftArrow, modifiers: [])
                        Button(action: { seekRight() }) { Text("right") }.keyboardShortcut(.rightArrow, modifiers: [])
                    }
                    .opacity(0)
                    .frame(height: 0.5)
                } else {
                    Text("Failed")
                }
            }
            .onAppear {
                loadVideo()
                if appState.isVideoPlaying {
                    player?.play()
                }
            }
            .onDisappear {
                unloadVideo()
            }
            .onChange(of: appState.combinationIndex) {
                unloadVideo()
                loadVideo()
            }
            .onChange(of: appState.combinations) {
                unloadVideo()
                loadVideo()
            }
        }
    }

    private func loadVideo() {
        if appState.combinations.isEmpty {
            return
        }
        let videosPath = appState.appConfig?.videosPath ?? ""
        let videoName = appState.getCurrentCombination()?.video.filename ?? ""
        let videoURL = URL(fileURLWithPath: videosPath).appendingPathComponent(videoName)
        self.player = AVPlayer(url: videoURL)
        isLoading = false
    }

    private func unloadVideo() {
        guard let player = self.player else { return }
        if (player.rate != 0) && (player.error == nil) {
            player.pause()
        }
        self.player = nil
        isLoading = true
    }

    private func seek(to percentage: Double) {
        guard let player = self.player else { return }
        guard let duration = player.currentItem?.duration else { return }
        let targetTime = CMTimeMultiplyByFloat64(duration, multiplier: percentage)
        player.seek(to: targetTime)
    }

    private func seekLeft() {
        guard let player = self.player else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTime(seconds: 10, preferredTimescale: 1))
        player.seek(to: newTime)
    }

    private func seekRight() {
        guard let player = self.player else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTime(seconds: 10, preferredTimescale: 1))
        player.seek(to: newTime)
    }
}

#Preview {
    VideoView()
        .environmentObject(AppState())
        .frame(width: 500, height: 400)
}
