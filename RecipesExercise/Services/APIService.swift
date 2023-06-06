import Foundation

protocol APIServiceProtocol {
    func loadData(for endpoint: Endpoint) async throws -> Data
}

extension APIServiceProtocol {
    func load<T: Decodable>(for endpoint: Endpoint) async throws -> T {
        let data = try await loadData(for: endpoint)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

enum Endpoint: String {
    case recipes
    
    var path: String { rawValue }
}

final class APIService: APIServiceProtocol {
    func loadData(for endpoint: Endpoint) async throws -> Data {
        guard let url = URL(string: endpoint.path) else {
            throw APIError.incorrectUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        return data
    }
}

class APIServiceMock: APIServiceProtocol {
    func loadData(for endpoint: Endpoint) async throws -> Data {
        let fileName = endpoint.path
        if let mockData = loadMockData(from: fileName) {
            return mockData
        } else {
            throw APIError.mockDataNotFound
        }
    }
    
    private func loadMockData(from fileName: String) -> Data? {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        
        do {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        } catch {
            return nil
        }
    }
}

enum APIError: Error {
    case decodingError
    case incorrectUrl
    case invalidResponse
    case mockDataNotFound
}

