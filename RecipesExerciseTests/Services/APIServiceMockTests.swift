import XCTest

final class APIServiceMockTests: XCTestCase {
    func testLoadDataSuccessful() async throws {
        // Given
        let apiService = APIServiceMock()
        let expectedData = try XCTUnwrap(loadMockData(from: "recipesSuccess"))
        
        // When
        let data = try await apiService.loadData(for: .recipes)
        
        // Then
        XCTAssertEqual(data, expectedData)
    }
    
    private func loadMockData(from fileName: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let fileUrl = bundle.url(forResource: fileName, withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: fileUrl)
            return data
        } catch {
            return nil
        }
    }
}
