import Combine
import Foundation

struct GlobalState {
    var combinations: [Combination]
    var combinationIndex: Int
    var filters: Filters
    var rpsConfig: RpsConfig

    var videos: [Video]
    var galleryObjectsMap: [String: Gallery]

    var isTgpShown: Bool
    var isVideoPlaying: Bool

    init() {
        let rpsConfig = getRpsConfig()
        self.rpsConfig = rpsConfig

        let galleries = getGalleries(galsPath: rpsConfig.galsPath)
        self.galleryObjectsMap = [:]
        for gallery in galleries {
            self.galleryObjectsMap[gallery.name] = gallery
        }
        let videos = getVideos(
            vidsPath: rpsConfig.vidsPath,
            videoRelations: rpsConfig.videoRelations,
            galleries: galleries.map(\.name),
            tags: rpsConfig.tags
        )
        self.videos = videos

        let videosInfo = getVideosInfo(videos: videos, galleries: galleries, tags: rpsConfig.tags, videoRelations: rpsConfig.videoRelations)
        self.filters = Filters(tags: rpsConfig.tags, studios: videosInfo.studios, cast: videosInfo.cast, galleries: galleries.map(\.name))
        self.combinations = []
        self.combinationIndex = 0

        self.isTgpShown = true
        self.isVideoPlaying = false

        generateCombinations()
    }

    mutating func moveToNextCombination() {
        if (self.combinations.isEmpty) {
            return
        }
        self.combinationIndex = (self.combinationIndex + 1) % self.combinations.count
    }

    mutating func moveToPrevCombination() {
        if (self.combinations.isEmpty) {
            return
        }
        self.combinationIndex = (self.combinationIndex - 1 + self.combinations.count) % self.combinations.count
    }

    func getCurrentCombination() -> Combination {
        if (self.combinations.isEmpty) {
            print("No combinations found.")
            exit(2)
        }
        return self.combinations[self.combinationIndex]
    }

    mutating func generateCombinations() {
        var combinations: [Combination] = []
        let selectedTags = Set(self.filters.tags.filter({ $0.isSelected }).map(\.value))
        let selectedGalleries = Set(self.filters.galleries.filter({ $0.isSelected }).map(\.value))
        let selectedStudios = Set(self.filters.studios.filter({ $0.isSelected }).map(\.value))
        let selectedCast = Set(self.filters.cast.filter({ $0.isSelected }).map(\.value))

        for video in self.videos {
            if !self.filters.tags.isEmpty && !selectedTags.isSubset(of: Set(video.tags)) {
                continue
            }

            if !selectedCast.isSubset(of: Set(video.cast)) {
                continue
            }

            if !selectedStudios.contains(video.studio) {
                continue
            }

            for gallery in video.galleries {
                if selectedGalleries.contains(gallery) {
                    combinations.append(Combination(video: video.name, gallery: gallery))
                }
            }
        }

        self.combinations = combinations.shuffled()
        self.combinationIndex = 0
    }
}

struct Combination: Codable, Equatable, Hashable {
    var video: String
    var gallery: String

    init(video: String, gallery: String) {
        self.video = video
        self.gallery = gallery
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(video)
        hasher.combine(gallery)
    }
}

struct Video: Codable, Equatable {
    var name: String
    var tags: [String]
    var galleries: [String]
    var studio: String
    var cast: [String]
    var title: String

    init(name: String, tags: [String], galleries: [String]) {
        self.name = name
        self.tags = tags
        self.galleries = galleries

        let name_components = name.split(separator: "-")
        self.studio = String(name_components.first!)
        self.title = String(name_components.last!)
        self.cast = name_components.dropFirst().dropLast().map { String($0) }
    }
}

struct Gallery: Codable, Equatable {
    var name: String
    var imgPaths: [String]

    init(name: String, galsPath: String) {
        self.name = name
        self.imgPaths = getGalleryImages(galsPath: galsPath, galName: name)
    }
}

struct Filters {
    var tags: [SelectableItem]
    var studios: [SelectableItem]
    var cast: [SelectableItem]
    var galleries: [SelectableItem]

    init(tags: [String], studios: [String], cast: [String], galleries: [String]) {
        self.tags = tags.map { (tag) -> SelectableItem in
            return SelectableItem(value: tag, isSelected: false)
        }
        self.studios = studios.map { (studio) -> SelectableItem in
            return SelectableItem(value: studio, isSelected: true)
        }
        self.cast = cast.map { (actor) -> SelectableItem in
            return SelectableItem(value: actor, isSelected: false)
        }
        self.galleries = galleries.map { (gallery) -> SelectableItem in
            return SelectableItem(value: gallery, isSelected: true)
        }
    }
}

struct SelectableItem {
    var value: String
    var isSelected: Bool

    init(value: String, isSelected: Bool = false) {
        self.value = value
        self.isSelected = isSelected
    }
}
