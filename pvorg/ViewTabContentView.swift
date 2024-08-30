import SwiftUI

struct ViewTabContentView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        VStack() {
            HStack {
                HStack {
                    Text(rpsData.data.getCurrentCombination().videoName)
                    Spacer()
                    Button(action: {
                        if (rpsData.data.isTgpShown) {
                            if (!rpsData.data.isVideoPlaying) {
                                rpsData.data.isVideoPlaying.toggle()
                            }
                        } else {
                            if (rpsData.data.isVideoPlaying) {
                                rpsData.data.isVideoPlaying.toggle()
                            }
                        }
                        rpsData.data.isTgpShown.toggle()
                    }) {
                        Text("TGP/VID")
                    }
                    .keyboardShortcut("p", modifiers: [])
                }
                .layoutPriority(3)

                HStack {
                    Button(action: {
                        rpsData.data.isVideoPlaying = false
                        rpsData.data.isTgpShown = true
                        rpsData.data.moveToPrevCombination()
                    }) {
                        Text("Prev")
                    }
                    .keyboardShortcut("b", modifiers: [])
                    Button(action: {
                        rpsData.data.isVideoPlaying = false
                        rpsData.data.isTgpShown = true
                        rpsData.data.moveToNextCombination()
                    }) {
                        Text("Next")
                    }
                    .keyboardShortcut("n", modifiers: [])
                    Spacer()
                    Text(rpsData.data.getCurrentCombination().galleryName)
                }.layoutPriority(1)
            }.layoutPriority(1)

            HStack {
                VideoTgpView()
                    .layoutPriority(3)

                GallerySlideshowView()
                    .layoutPriority(1)
            }
            .layoutPriority(9)
        }
        .padding()
    }
}

#Preview {
    ViewTabContentView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
