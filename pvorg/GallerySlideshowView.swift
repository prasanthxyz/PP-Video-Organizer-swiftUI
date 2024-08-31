import SwiftUI

struct GallerySlideshowView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    @State private var currentImageIndex: Int = 0
    @State private var timer: Timer?
    @State private var images: [String]

    init() {
        currentImageIndex = 0
        timer = nil
        images = []
    }

    var body: some View {
        if !rpsData.data.combinations.isEmpty {
            VStack {
                let image = images.isEmpty ? "" : images[currentImageIndex]
                if let nsImage = NSImage(contentsOfFile: image) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                } else {
                    Text("Image not found")
                }
            }
            .onAppear() {
                startSlideshow()
            }
            .onDisappear() {
                stopSlideshow()
            }
            .onChange(of: rpsData.data.combinationIndex) {
                stopSlideshow()
                startSlideshow()
            }
            .onChange(of: rpsData.data.combinations) {
                stopSlideshow()
                startSlideshow()
            }
        }
    }

    private func startSlideshow() {
        if rpsData.data.combinations.isEmpty {
            return
        }
        self.currentImageIndex = 0
        let galleryName = rpsData.data.getCurrentCombination().galleryName
        images = rpsData.data.galleryImages[galleryName] ?? []
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation {
                currentImageIndex = (currentImageIndex + 1) % images.count
            }
        }
    }

    private func stopSlideshow() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    GallerySlideshowView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
