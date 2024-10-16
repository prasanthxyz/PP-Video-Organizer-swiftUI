import Foundation

struct Gallery: Equatable, Hashable {
    var name: String
    var imageFiles: [String]
}

func parseGalleries(from galleriesPath: String) -> [Gallery] {
    var galleries: [Gallery] = []

    let fileManager = FileManager.default
    let galleriesPathURL = URL(fileURLWithPath: galleriesPath)

    do {
        let fileURLs = try fileManager.contentsOfDirectory(at: galleriesPathURL, includingPropertiesForKeys: nil)

        for fileURL in fileURLs {
            if fileURL.hasDirectoryPath && fileURL.lastPathComponent.first != "." {
                let galleryName = fileURL.lastPathComponent
                galleries.append(
                    Gallery(
                        name: galleryName,
                        imageFiles: getGalleryImages(galleryPath: galleriesPathURL.appendingPathComponent(galleryName))
                    )
                )
            }
        }
    } catch {
        print("Error reading galleries files from directory: \(error)")
    }
    return galleries
}

func getGalleryImages(galleryPath: URL) -> [String] {
    let imageExts: Set<String> = ["png", "jpg", "jpeg", "bmp", "gif"]
    var galleryImages = [String]()
    do {
        let files = try FileManager.default.contentsOfDirectory(at: galleryPath, includingPropertiesForKeys: nil)
        for imgPath in files {
            if imgPath.isFileURL
                && imageExts.contains(imgPath.pathExtension.lowercased())
                && imgPath.lastPathComponent.first != "."
            {
                galleryImages.append(imgPath.path)
            }
        }
    } catch {
        print("Error reading gallery files from directory: \(error)")
    }

    return galleryImages
}
