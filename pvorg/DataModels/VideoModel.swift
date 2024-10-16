import Foundation

struct Video: Equatable, Hashable {
    var filename: String
    var studio: String
    var actors: [String]
    var title: String
    var relatedGalleries: [String]
    var tags: [String]

    init(
        filename: String,
        studio: String,
        actors: [String],
        title: String,
        relatedGalleries: [String] = [],
        tags: [String] = []
    ) {
        self.filename = filename
        self.studio = studio
        self.actors = actors
        self.title = title
        self.relatedGalleries = relatedGalleries
        self.tags = tags
    }
}

func parseVideos(
    from videosPath: String,
    with relations: [String: VideoRelation],
    allTags: [String],
    allGalleries: [String]
) -> [Video] {
    var videos: [Video] = []
    let fileManager = FileManager.default
    let videoPath = URL(fileURLWithPath: videosPath)

    do {
        let fileURLs = try fileManager.contentsOfDirectory(
            at: videoPath, includingPropertiesForKeys: nil)

        for fileURL in fileURLs {
            if fileURL.hasDirectoryPath == false
                && fileURL.lastPathComponent.first != "."
            {
                let videoName = fileURL.lastPathComponent
                let filenameWithoutExtension = stripFileExtension(videoName)
                let components = filenameWithoutExtension.split(separator: "-")

                guard components.count >= 3 else {
                    print("Invalid video filename format: \(videoName)")
                    continue
                }

                let studio = String(components[0])
                let actors = components[1..<components.count - 1].map {
                    String($0)
                }
                let title = String(components.last!)

                let relation =
                    relations[videoName]
                    ?? VideoRelation(galleries: allGalleries, tags: allTags)

                videos.append(
                    Video(
                        filename: videoName,
                        studio: studio,
                        actors: actors,
                        title: title,
                        relatedGalleries: relation.galleries,
                        tags: relation.tags
                    )
                )
            }
        }
    } catch {
        print("Error reading video files from directory: \(error)")
    }

    return videos
}

func stripFileExtension(_ filename: String) -> String {
    var components = filename.components(separatedBy: ".")
    guard components.count > 1 else { return filename }
    components.removeLast()
    return components.joined(separator: ".")
}
