import SwiftUI

struct TgpView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        if !rpsData.data.combinations.isEmpty {
            let vidPath = rpsData.data.rpsConfig.vidsPath
            let videoName = rpsData.data.getCurrentCombination().video
            let tgpPath = URL(fileURLWithPath: vidPath).appendingPathComponent("img").appendingPathComponent(videoName + ".jpg")
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
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
