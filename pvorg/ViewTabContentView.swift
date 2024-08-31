import SwiftUI

struct ViewTabContentView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        if rpsData.data.combinations.isEmpty {
            VStack {
                Text("No combinations found.")
                    .font(.title)
            }
        } else {
            GeometryReader { geometry in
                VStack {
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
                        .frame(width: geometry.size.width * 0.75)

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
                        }
                        .frame(width: geometry.size.width * 0.25)
                    }

                    HStack {
                        VideoTgpView()
                            .frame(width: geometry.size.width * 0.75)

                        GallerySlideshowView()
                            .frame(width: geometry.size.width * 0.25)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ViewTabContentView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
