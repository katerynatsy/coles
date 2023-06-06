import Foundation

struct RecipeViewObject: Hashable {
    let id: RecipeID
    let thumbnail: String
    let description: String
    let imageLabel: String
    
    var title: String { Localized.recipe.string }
}

extension RecipeModel {
    var recipeViewObject: RecipeViewObject {
        RecipeViewObject(
            id: id,
            thumbnail: dynamicThumbnail,
            description: dynamicTitle,
            imageLabel: dynamicThumbnailAlt
        )
    }    
}
