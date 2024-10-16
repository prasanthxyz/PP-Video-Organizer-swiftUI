import SwiftUI

struct TgpView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if !appState.combinations.isEmpty {
            let videosPath = appState.appConfig?.videosPath ?? ""
            let videoName = appState.getCurrentCombination()?.video.filename ?? ""
            let tgpPath = URL(fileURLWithPath: videosPath)
                .appendingPathComponent("img")
                .appendingPathComponent(videoName + ".jpg")
            if let nsImage = NSImage(contentsOfFile: tgpPath.path) {
                VStack {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                }
            } else {
                Text("Image not found: " + tgpPath.path)
            }
        }
    }
}

#Preview {
    TgpView()
        .environmentObject(AppState())
        .frame(width: 500, height: 400)
}
