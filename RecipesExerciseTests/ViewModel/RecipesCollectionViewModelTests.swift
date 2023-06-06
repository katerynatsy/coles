import Combine
import XCTest
@testable import RecipesExercise

final class RecipesViewModelTests: XCTestCase {
    var viewModel: RecipesViewModel!
    var recipesManager: RecipesManager!
    var imageLoader: ImageLoaderProtocol!
    var cancellables: Set<AnyCancellable>!
    var recipeMock = RecipeViewObject.mock!

    override func setUp() {
        super.setUp()
        
        recipesManager = RecipesManager(environment: .test)
        imageLoader = MockImageLoader()
        viewModel = RecipesViewModel(
            recipesManager: recipesManager,
            imageLoader: imageLoader
        )
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        recipesManager = nil
        imageLoader = nil
        cancellables = nil
        
        super.tearDown()
    }
    
    func testInitialCollectionGroupValue() {
        let expectation = XCTestExpectation(description: "Test set up with empty collectionGroup")
        
        XCTAssertEqual(viewModel.collectionGroups.count, 0)
        expectation.fulfill()
    }
    
    func testDataRefresh() {
        let expectation = XCTestExpectation(
            description: "RecipesViewModel fetches data and updates properties."
        )
        
        //When
        viewModel.refresh()
        
        let asyncWaitDuration = 2
        let delay: DispatchTime = .now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            // Verify state after
            XCTAssertEqual(self.viewModel.collectionGroups.count, 1)
            XCTAssertEqual(self.viewModel.collectionGroups[0].items.count, 8)
            XCTAssertEqual(self.viewModel.collectionGroups[0].items[0].id, "/content/dam/coles/inspire-create/thumbnails/Gnocchi-with-pumpkin-and-whipped-ricotta-480x288.jpg")
            // Then
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a certain interval
        wait(for: [expectation], timeout: TimeInterval(asyncWaitDuration))
    }

    func testViewModelForItem() {
        //Set up mock collectionGroup item
        let item: RecipesViewModel.Item = .recipe(recipeMock)

        let detailsViewModel = viewModel.viewModel(for: item)

        XCTAssertEqual(detailsViewModel.recipeId, item.id)
    }

    func testImageDataForItem() {
        // Set up mock collectionGroup item
        let item: RecipesViewModel.Item = .recipe(recipeMock)
        let mockImageData = UIImage(systemName: "photo")?.jpegData(compressionQuality: 0.5)

        // Call the imageData(for:) method
        viewModel.imageData(for: item)
            .sink { XCTAssertEqual($0, mockImageData) }
            .store(in: &cancellables)
    }
}
