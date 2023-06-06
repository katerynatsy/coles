import Foundation

enum ViewIdentifier {
    enum Recipes: String {
        case recipesViewController
        case recipesCollectionView
    }
    
    enum RecipeCell: String{
        case recipeCellTitleLabel
        case recipeCellSubtitleLabel
        case recipeCellThumbnailView
    }
    
    enum RecipeDetails: String {
        case recipeDetailsView
        case recipeDetailsTitleLable
        case recipeDetailsDescriptionLabel
        case recipeDetailsThumbnailView
        case recipeDetailsRecipeSpecs
        case recipeDetailsIngridientsTitleLabel
        case recipeDetailsIngridientsListLabel
        case recipeDetailsNavigationBar
        case recipeDetailsBackButtonLabel
    }
}
