import SwiftUI

struct TgpView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        if (rpsData.data.isTgpShown) {
            let vidPath = rpsData.data.rpsConfig.vidPath
            let videoName = rpsData.data.getCurrentCombination().videoName
            let tgpPath = URL(fileURLWithPath: vidPath).appendingPathComponent("img").appendingPathComponent(videoName + ".jpg")
            if let nsImage = NSImage(contentsOfFile: tgpPath.path) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Image not found: " + tgpPath.path)
            }
        } else {

        }
    }
}

#Preview {
    TgpView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
