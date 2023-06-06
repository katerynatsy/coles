import XCTest

final class RecipesManagerTests: XCTestCase {
    private var recipesManager: RecipesManager!
    
    override func setUp() {
        super.setUp()
        recipesManager = RecipesManager(environment: .test)
    }
    
    override func tearDown() {
        recipesManager = nil
        super.tearDown()
    }
    
    func testGetRecipesListSuccessful() async throws {
        // Given
        let mockRecipesResponse = try XCTUnwrap(JSONTestData<RecipesResponse>.loadJson(filename: "recipesSuccess"))
                
        // When
        let recipeViewModels = await recipesManager.getRecipesList()
        
        // Then
        XCTAssertEqual(recipeViewModels.count, mockRecipesResponse.recipes.count)
        
        // Verify that the recipes are sorted by ID
        let recipeIDs = recipeViewModels.map { $0.id }
        XCTAssertEqual(
            recipeIDs,
            mockRecipesResponse.recipes.map(\.id).sorted { $0 < $1 }
        )
    }
    
    func testGetRecipeDetailsSuccessful() async throws {
        // Given
        let mockRecipesResponse = try XCTUnwrap(JSONTestData<RecipesResponse>.loadJson(filename: "recipesSuccess"))
                
        // Select a recipe ID to retrieve details
        let recipeID = mockRecipesResponse.recipes.map(\.id).first ?? ""
        
        // When
        let recipeDetails = await recipesManager.getRecipeDetails(for: recipeID)
        
        // Then
        XCTAssertNotNil(recipeDetails)
        XCTAssertEqual(recipeDetails?.id, recipeID)
    }
    
    func testGetRecipeDetailsFailure() async {
        // When
        let recipeDetails = await recipesManager.getRecipeDetails(for: "notExist")
        
        // Then
        XCTAssertNil(recipeDetails)
    }
}
