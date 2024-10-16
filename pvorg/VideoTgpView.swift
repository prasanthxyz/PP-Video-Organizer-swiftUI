import SwiftUI

struct VideoTgpView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if !appState.combinations.isEmpty {
            if appState.isTgpShown {
                TgpView()
            } else {
                VideoView()
            }
        }
    }
}

#Preview {
    VideoTgpView()
        .environmentObject(AppState())
        .frame(width: 500, height: 400)
}
