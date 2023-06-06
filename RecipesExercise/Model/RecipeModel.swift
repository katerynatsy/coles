import Foundation

typealias RecipeID = String

struct RecipesResponse: Decodable {
    let recipes: [RecipeModel]
}

struct RecipeModel: Decodable, Hashable {
    var id: RecipeID { dynamicThumbnail }
    let dynamicTitle: String
    let dynamicDescription: String
    let dynamicThumbnail: String
    let dynamicThumbnailAlt: String
    let recipeDetails: RecipeDetailsModel
    let ingredients: [IngridientModel]
}

struct RecipeDetailsModel: Decodable, Hashable {
    let amountLabel: String
    let amountNumber: Int
    let prepLabel: String
    let prepTime: String
    let prepNote: String?
    let cookingLabel: String
    let cookingTime: String
    let cookTimeAsMinutes: Double
    let prepTimeAsMinutes: Double
}

struct IngridientModel: Decodable, Hashable {
    let ingredient: String
}

extension RecipeModel {
    func contains(_ string: String) -> Bool {
        string.isEmpty ||
        dynamicTitle.contains(string) ||
        dynamicDescription.contains(string) ||
        ingredients.map(\.ingredient).filter { $0.contains(string) }.first != nil
    }
}
