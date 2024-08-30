import SwiftUI
import AVFoundation

struct VideoPlayerView: NSViewRepresentable {
    var player: AVPlayer

    func makeNSView(context: Context) -> NSView {
        return PlayerView(player: player)
    }

    func updateNSView(_ nsView: NSView, context: Context) {
    }
}

class PlayerView: NSView {
    private var playerLayer: AVPlayerLayer

    init(player: AVPlayer) {
        self.playerLayer = AVPlayerLayer(player: player)
        super.init(frame: .zero)
        self.wantsLayer = true
        self.layer = playerLayer
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()
        playerLayer.frame = self.bounds
    }
}

struct VideoView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    @State private var player: AVPlayer?
    @State private var isLoading = true
    @State private var currentTime: Double = 0.0
    @State private var duration: Double = 0.0
    @State private var playerObserver: Any?

    var body: some View {
        VStack {
            if isLoading {
                Text("Loading...")
            } else if let player = player {
                VideoPlayerView(player: player)
                    .onChange(of: rpsData.data.isVideoPlaying) { newValue in
                                            if newValue {
                                                player.play()
                                            } else {
                                                player.pause()
                                            }
                                        }

                HStack {
                    Button(action: {
                        rpsData.data.isVideoPlaying.toggle()
                    }) {
                        Image(systemName: rpsData.data.isVideoPlaying ? "pause.fill" : "play.fill")
                            .font(.largeTitle)
                    }
                    .keyboardShortcut(.space, modifiers: [])
                    Slider(value: Binding(
                                        get: {
                                            currentTime
                                        },
                                        set: { newValue in
                                            currentTime = newValue
                                            let time = CMTimeMakeWithSeconds(newValue, preferredTimescale: player.currentTime().timescale)
                                            player.seek(to: time)
                                        }
                                    ), in: 0...duration)

                                    Text("\(formattedTime(currentTime)) / \(formattedTime(duration))")
                }

                HStack {
                    Button(action: {seek(to:0.0)}) {Text("0")}.keyboardShortcut("0", modifiers: [])
                    Button(action: {seek(to:0.1)}) {Text("1")}.keyboardShortcut("1", modifiers: [])
                    Button(action: {seek(to:0.2)}) {Text("2")}.keyboardShortcut("2", modifiers: [])
                    Button(action: {seek(to:0.3)}) {Text("3")}.keyboardShortcut("3", modifiers: [])
                    Button(action: {seek(to:0.4)}) {Text("4")}.keyboardShortcut("4", modifiers: [])
                    Button(action: {seek(to:0.5)}) {Text("5")}.keyboardShortcut("5", modifiers: [])
                    Button(action: {seek(to:0.6)}) {Text("6")}.keyboardShortcut("6", modifiers: [])
                    Button(action: {seek(to:0.7)}) {Text("7")}.keyboardShortcut("7", modifiers: [])
                    Button(action: {seek(to:0.8)}) {Text("8")}.keyboardShortcut("8", modifiers: [])
                    Button(action: {seek(to:0.9)}) {Text("9")}.keyboardShortcut("9", modifiers: [])
                }
                .opacity(0)
                .frame(height: 0.5)
            } else {
                Text("Failed")
            }
        }
        .onAppear() {
            loadVideo()
        }
        .onDisappear() {
            unloadVideo()
        }
    }

    private func loadVideo() {
        let vidPath = rpsData.data.rpsConfig.vidPath
        let videoName = rpsData.data.getCurrentCombination().videoName
        let videoURL = URL(fileURLWithPath: vidPath).appendingPathComponent(videoName)
        let player = AVPlayer(url: videoURL)
        player.play()
        duration = CMTimeGetSeconds(player.currentItem?.asset.duration ?? CMTime.zero)
        playerObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
            self.currentTime = CMTimeGetSeconds(time)
        }
        self.player = player
        isLoading = false
    }

    private func unloadVideo() {
        if let observer = playerObserver {
            player?.removeTimeObserver(observer)
        }
    }

    private func formattedTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func seek(to percentage: Double) {
        guard let player = self.player else {return}
        guard let duration = player.currentItem?.duration else { return }
        let targetTime = CMTimeMultiplyByFloat64(duration, multiplier: percentage)
        player.seek(to: targetTime)
    }
}

#Preview {
    VideoView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
