import Combine
import XCTest
@testable import RecipesExercise

final class RecipeDetailsViewModelTests: XCTestCase {
    var viewModel: RecipeDetailsViewModel!
    var recipesManager: RecipesManager!
    var imageLoader: ImageLoaderProtocol!
    var cancellables: Set<AnyCancellable>!
    
    var recipeMock: RecipeViewObject = .mock!
    
    override func setUp() {
        super.setUp()
        
        recipesManager = RecipesManager(environment: .test)
        imageLoader = MockImageLoader()
        viewModel = RecipeDetailsViewModel(
            id: recipeMock.id,
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
    
    func testInitialSetup() {
        XCTAssertEqual(viewModel.recipeId, recipeMock.id)
        XCTAssertEqual(viewModel.testableRecipeDetails, nil)
    }
    
    func testDataRefresh() {
        // Given
        let recipeItemDetails = RecipeModel.mock?.itemDetailsViewObject
        
        let expectation = XCTestExpectation(description: "Wait for data refresh")
        
        // When
        viewModel.fetchRecipeDetailsData()
        
        let asyncWaitDuration = 2
        let delay: DispatchTime = .now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            // Then
            XCTAssertEqual(self.viewModel.testableRecipeDetails?.title, recipeItemDetails?.title)
            XCTAssertEqual(self.viewModel.testableRecipeDetails?.description, recipeItemDetails?.description)
            
            // Fulfill the expectation after checking the assertions
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a certain interval
        wait(for: [expectation], timeout: TimeInterval(asyncWaitDuration))

        /// TBD: Verify that the recipesManager's getRecipeDetails(for:) method was called with the correct recipeId
    }
}
