import Foundation

extension RecipeModel {
    static let mock = JSONTestData<RecipeModel>.loadJson(filename: "recipeModelMock")
}

extension RecipeViewObject {
    static var mock: RecipeViewObject? {
        guard let recipeModel = RecipeModel.mock else { return nil }
        return recipeModel.recipeViewObject
    }
}

extension RecipeDetailsModel {
    static let mock: RecipeDetailsModel? = RecipeModel.mock?.recipeDetails
}
