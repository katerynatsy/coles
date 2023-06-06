import Combine
import Foundation

final class RecipeDetailsViewModel: ObservableObject {
    let recipeId: RecipeID
    private let recipesManager: RecipesManager
    private let imageLoader: ImageLoaderProtocol
    @Published private var recipeDetails: RecipeItemDetailsViewObject?
    
    init(
        id: RecipeID,
        recipesManager: RecipesManager,
        imageLoader: ImageLoaderProtocol
    ) {
        self.recipeId = id
        self.recipesManager = recipesManager
        self.imageLoader = imageLoader
    }
}

extension RecipeDetailsViewModel {
    func fetchRecipeDetailsData() {
        Task {
            recipeDetails = await recipesManager.getRecipeDetails(for: recipeId)
        }
    }
    
    var ingridientsTitle: String { Localized.ingridients.string }
    
    var showLoadingState: AnyPublisher<Bool, Never> {
        $recipeDetails
            .map { $0 == nil }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var titlePublisher: AnyPublisher<String?, Never> {
        $recipeDetails
            .map(\.?.title)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var descriptionPublisher: AnyPublisher<String?, Never> {
        $recipeDetails
            .map(\.?.description)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var recipeSpecsPublisher: AnyPublisher<RecipeSpecsViewObject?, Never> {
        $recipeDetails
            .map(\.?.specs)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var ingridientsPublisher: AnyPublisher<String?, Never> {
        $recipeDetails
            .map { details in
                let ingridientCollection = details?.ingredients.map(\.ingredient)
                return ingridientCollection?.reduce("", { $0 + ">\t\($1)\u{2029}" })
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var imagePublisher: AnyPublisher<Data?, Never> {
        imageLoader.loadImage(for: recipeId)
    }
    
    var imageLabel: AnyPublisher<String?, Never> {
        $recipeDetails
            .map(\.?.imageLabel)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

extension RecipeDetailsViewModel {
    #if DEBUG
    // Testing-specific wrapper for recipeDetails
    var testableRecipeDetails: RecipeItemDetailsViewObject? {
        recipeDetails
    }
    #endif
}

private extension RecipeItemDetailsViewObject {
    var specs: RecipeSpecsViewObject {
        RecipeSpecsViewObject(
            amountLabel: amountLabel,
            amountNumber: amountNumber,
            prepLabel: prepLabel,
            prepTime: prepTime,
            prepNote: prepNote,
            cookingLabel: cookingLabel,
            cookingTime: cookingTime
        )
    }
}
