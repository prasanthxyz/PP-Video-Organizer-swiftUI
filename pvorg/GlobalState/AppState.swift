import Foundation

class AppState: ObservableObject {
    @Published var appConfig: AppConfig? = nil

    @Published var videos: [Video] = []
    @Published var galleries: [Gallery] = []
    @Published var combinations: [Combination] = []
    @Published var combinationIndex: Int = 0

    @Published var selectedGalleries: Set<String> = []
    @Published var selectedStudios: Set<String> = []
    @Published var selectedTags: Set<String> = []
    @Published var selectedCast: Set<String> = []

    @Published var isTgpShown: Bool = true
    @Published var isVideoPlaying: Bool = false

    init() {
        loadConfig()
    }

    func loadConfig() {
        let configFileURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("pvorg.json")
        let config: AppConfig = load(configFileURL)
        appConfig = config

        galleries = parseGalleries(from: config.galleriesPath)
        videos = parseVideos(
            from: config.videosPath,
            with: config.videoRelations,
            allTags: config.tags,
            allGalleries: galleries.map(\.name)
        )
        selectedGalleries = Set(galleries.map { $0.name })
        selectedStudios = Set(videos.map { $0.studio })

        isTgpShown = true
        isVideoPlaying = false

        generateCombinations()
    }

    func generateCombinations() {
        combinations = []

        for video in videos {
            if selectedStudios.contains(video.studio)
                && containsAll(video.actors, in: selectedCast)
                && containsAll(video.tags, in: selectedTags)
            {
                for gallery in galleries {
                    if selectedGalleries.contains(gallery.name) {
                        combinations.append(Combination(video: video, gallery: gallery))
                    }
                }
            }
        }
    }

    func getCurrentCombination() -> Combination? {
        if combinations.isEmpty {
            return nil
        }

        return combinations[combinationIndex]
    }

    func moveToNextCombination() {
        if combinations.isEmpty {
            return
        }
        combinationIndex += 1
        if combinationIndex >= combinations.count {
            combinationIndex = 0
        }
    }

    func moveToPrevCombination() {
        if combinations.isEmpty {
            return
        }
        combinationIndex -= 1
        if combinationIndex < 0 {
            combinationIndex = combinations.count - 1
        }
    }

    private func containsAll(_ list: [String], in set: Set<String>) -> Bool {
        return set.isEmpty || set.isSubset(of: list)
    }
}
