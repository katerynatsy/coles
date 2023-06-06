import Foundation
// TODO: dssd
struct RecipeItemDetailsViewObject: Hashable {
    let id: RecipeID
    let title: String
    let description: String
    let imageLabel: String
    let amountLabel: String
    let amountNumber: Int
    let prepLabel: String
    let prepTime: String
    let prepNote: String?
    let cookingLabel: String
    let cookingTime: String
    let cookTimeAsMinutes: Double
    let prepTimeAsMinutes: Double
    let ingredients: [IngridientModel]
}

extension RecipeModel {
    var itemDetailsViewObject: RecipeItemDetailsViewObject {
        RecipeItemDetailsViewObject(
            id: id,
            title: dynamicTitle,
            description: dynamicDescription,
            imageLabel: dynamicThumbnail,
            amountLabel: recipeDetails.amountLabel,
            amountNumber: recipeDetails.amountNumber,
            prepLabel: recipeDetails.prepLabel,
            prepTime: recipeDetails.prepTime,
            prepNote: recipeDetails.prepNote,
            cookingLabel: recipeDetails.cookingLabel,
            cookingTime: recipeDetails.cookingTime,
            cookTimeAsMinutes: recipeDetails.cookTimeAsMinutes,
            prepTimeAsMinutes: recipeDetails.prepTimeAsMinutes,
            ingredients: ingredients
        )
    }
}
