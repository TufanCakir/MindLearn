import Foundation

enum ContentRepositoryError: LocalizedError {
    case resourceNotFound(String)
    case unreadableResource(String, underlying: Error)
    case decodingFailed(String, underlying: Error)
    case emptyContent(String)

    var errorDescription: String? {
        switch self {
        case .resourceNotFound(let resource):
            "Content resource not found: \(resource).json"
        case .unreadableResource(let resource, _):
            "Content resource could not be read: \(resource).json"
        case .decodingFailed(let resource, _):
            "Content resource contains invalid data: \(resource).json"
        case .emptyContent(let resource):
            "Content resource is empty: \(resource).json"
        }
    }
}

@MainActor
final class BundleContentRepository<Content: Decodable, File: RawRepresentable & Hashable>
where File.RawValue == String {
    typealias DataProvider = (File) throws -> Data

    private let dataProvider: DataProvider
    private let decoder: JSONDecoder
    private var cache: [File: [Content]] = [:]

    convenience init(bundle: Bundle = .main, subdirectory: String? = nil) {
        self.init { file in
            guard let url = bundle.url(
                forResource: file.rawValue,
                withExtension: "json",
                subdirectory: subdirectory
            ) ?? bundle.url(forResource: file.rawValue, withExtension: "json") else {
                throw ContentRepositoryError.resourceNotFound(file.rawValue)
            }

            do {
                return try Data(contentsOf: url)
            } catch {
                throw ContentRepositoryError.unreadableResource(
                    file.rawValue,
                    underlying: error
                )
            }
        }
    }

    init(
        decoder: JSONDecoder = JSONDecoder(),
        dataProvider: @escaping DataProvider
    ) {
        self.decoder = decoder
        self.dataProvider = dataProvider
    }

    func load(_ file: File) throws -> [Content] {
        if let cached = cache[file] {
            return cached
        }

        let data = try dataProvider(file)

        do {
            let content = try decoder.decode([Content].self, from: data)
            guard !content.isEmpty else {
                throw ContentRepositoryError.emptyContent(file.rawValue)
            }
            cache[file] = content
            return content
        } catch let error as ContentRepositoryError {
            throw error
        } catch {
            throw ContentRepositoryError.decodingFailed(
                file.rawValue,
                underlying: error
            )
        }
    }

    func loadAll(_ files: [File]) throws -> [Content] {
        try files.flatMap(load)
    }
}
