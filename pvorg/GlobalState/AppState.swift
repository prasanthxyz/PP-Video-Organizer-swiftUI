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
            let studioMatches = selectedStudios.contains(video.studio)
            let castMatches = containsAll(itemsList: video.actors, requiredItems: selectedCast)
            let tagsMatches = containsAll(itemsList: video.tags, requiredItems: selectedTags)

            if studioMatches && castMatches && tagsMatches {
                for gallery in galleries {
                    if selectedGalleries.contains(gallery.name) && video.relatedGalleries.contains(gallery.name) {
                        combinations.append(Combination(video: video, gallery: gallery))
                    }
                }
            }
        }

        combinations.shuffle()
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

    private func containsAll(itemsList: [String], requiredItems: Set<String>) -> Bool {
        return requiredItems.isEmpty || requiredItems.isSubset(of: Set(itemsList))
    }
}
