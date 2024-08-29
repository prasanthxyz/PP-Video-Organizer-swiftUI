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
                    }) {
                        Text("TGP/VID")
                    }
                }
                .layoutPriority(3)

                HStack {
                    Button(action: {
                        rpsData.data.moveToPrevCombination()
                    }) {
                        Text("Prev")
                    }
                    Button(action: {
                        rpsData.data.moveToNextCombination()
                    }) {
                        Text("Next")
                    }
                    Spacer()
                    Text(rpsData.data.getCurrentCombination().galleryName)
                }.layoutPriority(1)
            }.layoutPriority(1)

            HStack {
                VStack {
                    Text("VIDEO/TGP")
                }
                .layoutPriority(3)

                VStack {
                    Text("SLIDESHOW")
                }
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
