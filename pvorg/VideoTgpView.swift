import SwiftUI

struct VideoTgpView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        if (rpsData.data.isTgpShown) {
            TgpView()
        } else {
            VideoView()
        }
    }
}

#Preview {
    VideoTgpView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
