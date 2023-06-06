import XCTest

final class RecipesExerciseUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testRecipesCollectionViewExist() {
        // Perform necessary actions to navigate to the RecipesViewController
        
        // Verify the view controller is displayed
        XCTAssertTrue(app.otherElements[ViewIdentifier.Recipes.recipesViewController.rawValue].exists)
        
        // Verify the collection view is displayed
        let collectionView = app.collectionViews[ViewIdentifier.Recipes.recipesCollectionView.rawValue]
        XCTAssertTrue(collectionView.exists)
                
        // Example: Assert the presence of a specific cell
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
