import SwiftUI

struct TgpView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        let vidPath = rpsData.data.rpsConfig.vidPath
        let videoName = rpsData.data.getCurrentCombination().videoName
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

#Preview {
    TgpView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
