import SwiftUI

struct GallerySlideshowView: View {
    @EnvironmentObject var appState: AppState

    @State private var currentImageIndex: Int = 0
    @State private var timer: Timer?
    @State private var images: [String]

    init() {
        currentImageIndex = 0
        timer = nil
        images = []
    }

    var body: some View {
        if !appState.combinations.isEmpty {
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
            .onAppear {
                startSlideshow()
            }
            .onDisappear {
                stopSlideshow()
            }
            .onChange(of: appState.combinationIndex) {
                stopSlideshow()
                startSlideshow()
            }
            .onChange(of: appState.combinations) {
                stopSlideshow()
                startSlideshow()
            }
        }
    }

    private func startSlideshow() {
        if appState.combinations.isEmpty {
            return
        }
        timer?.invalidate()
        timer = nil
        self.currentImageIndex = 0
        images = appState.getCurrentCombination()?.gallery.imageFiles.shuffled() ?? []
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
        .environmentObject(AppState())
        .frame(width: 500, height: 400)
}
