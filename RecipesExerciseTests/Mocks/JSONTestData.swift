import Foundation
import XCTest

public enum JSONTestData<T: Decodable> {
    enum JSONError: String, Error {
        case invalidData
    }

    public static func loadJson(filename: String) -> T? {
        let bundle = Bundle(for: APIServiceMockTests.self)
        
        guard let fileUrl = bundle.url(forResource: filename, withExtension: "json") else {
            XCTFail("JSON file \(filename) not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            print("JSONTestData decoding error: \(error)")
        }
        return nil
    }
}
