import Foundation

func getRpsConfig() -> RpsConfig {
    let fileURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("pvorg.json")
    let rpsConfig: RpsConfig = load(fileURL)
    return rpsConfig
}

func getVideos(
    vidsPath: String,
    videoRelations: [String: VideoRelations],
    galleries: [String],
    tags: [String]
) -> [Video] {
    var videos: [Video] = []
    let fileManager = FileManager.default
    let videoPath = URL(fileURLWithPath: vidsPath)

    do {
        let fileURLs = try fileManager.contentsOfDirectory(at: videoPath, includingPropertiesForKeys: nil)

        for fileURL in fileURLs {
            if fileURL.hasDirectoryPath == false && fileURL.lastPathComponent.first != "." {
                let videoName = fileURL.lastPathComponent
                let videoTags = videoRelations[videoName]?.tags ?? tags
                let videoGalleries = videoRelations[videoName]?.galleries ?? galleries
                videos.append(Video(
                    name: videoName,
                    tags: videoTags,
                    galleries: videoGalleries
                ))
            }
        }
    } catch {
        return []
    }

    return videos
}

func getGalleryImages(galsPath: String, galName: String) -> [String] {
    let imageExts: Set<String> = ["png", "jpg", "jpeg", "bmp", "gif"]
    var galleryImages = [String]()
    let galleryPath = URL(fileURLWithPath: galsPath).appendingPathComponent(galName)
    do {
        let files = try FileManager.default.contentsOfDirectory(at: galleryPath, includingPropertiesForKeys: nil)
        for imgPath in files {
            if imgPath.isFileURL && imageExts.contains(imgPath.pathExtension.lowercased()) && imgPath.lastPathComponent.first != "." {
                galleryImages.append(imgPath.path)
            }
        }
    } catch {
    }

    return galleryImages
}

func getGalleries(galsPath: String) -> [Gallery] {
    var galleries: [Gallery] = []
    let fileManager = FileManager.default
    let galleryPath = URL(fileURLWithPath: galsPath)

    do {
        let fileURLs = try fileManager.contentsOfDirectory(at: galleryPath, includingPropertiesForKeys: nil)

        for fileURL in fileURLs {
            if fileURL.hasDirectoryPath && fileURL.lastPathComponent.first != "." {
                let galleryName = fileURL.lastPathComponent
                galleries.append(Gallery(
                    name: galleryName,
                    galsPath: galsPath
                ))
            }
        }
    } catch {
        return []
    }
    return galleries
}

func getVideosInfo(
    videos: [Video],
    galleries: [Gallery],
    tags: [String],
    videoRelations: [String: VideoRelations]
) -> (studios: [String], cast: [String]) {
    return (
        studios: Array(Set(videos.map(\.studio))),
        cast: Array(Set(videos.flatMap(\.cast)))
    )
}
