import SwiftUI

struct ViewTabContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.combinations.isEmpty {
            VStack {
                Text("No combinations found.")
                    .font(.title)
            }
        } else {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        HStack {
                            Text(appState.getCurrentCombination()?.video.filename ?? "")
                            Spacer()
                            Button(action: {
                                if appState.isTgpShown {
                                    if !appState.isVideoPlaying {
                                        appState.isVideoPlaying.toggle()
                                    }
                                } else {
                                    if appState.isVideoPlaying {
                                        appState.isVideoPlaying.toggle()
                                    }
                                }
                                appState.isTgpShown.toggle()
                            }) {
                                Text("TGP/VID")
                            }
                            .keyboardShortcut("p", modifiers: [])
                        }
                        .frame(width: geometry.size.width * 0.75)

                        HStack {
                            Button(action: {
                                appState.isVideoPlaying = false
                                appState.isTgpShown = true
                                appState.moveToPrevCombination()
                            }) {
                                Text("Prev")
                            }
                            .keyboardShortcut("b", modifiers: [])
                            Button(action: {
                                appState.isVideoPlaying = false
                                appState.isTgpShown = true
                                appState.moveToNextCombination()
                            }) {
                                Text("Next")
                            }
                            .keyboardShortcut("n", modifiers: [])
                            Spacer()
                            Text(appState.getCurrentCombination()?.gallery.name ?? "")
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
        .environmentObject(AppState())
        .frame(width: 500, height: 400)
}
