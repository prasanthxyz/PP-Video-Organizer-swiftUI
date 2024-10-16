import Foundation

struct RpsConfig: Codable {
    var vidsPath: String
    var galsPath: String
    var tags: [String]
    var videoRelations: [String: VideoRelations]
}

struct VideoRelations: Codable {
    var galleries: [String]
    var tags: [String]
}

func load<T: Decodable>(_ filename: URL, as type: T.Type = T.self) -> T {
    let data: Data

    do {
        data = try Data(contentsOf: filename)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
