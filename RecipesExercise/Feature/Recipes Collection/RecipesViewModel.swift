import Foundation
import Combine

final class RecipesViewModel: ObservableObject, HapticGeneratable {
    struct CollectionGroup: Equatable {
        let section: Section
        let items: [Item]
    }
    
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case recipe(RecipeViewObject)
    }
    
    @Published var collectionGroups: [CollectionGroup] = []
    @Published var searchText = ""
    
    private let recipesManager: RecipesManager
    private let imageLoader: ImageLoaderProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        recipesManager: RecipesManager,
        imageLoader: ImageLoaderProtocol = ImageLoader()
    ) {
        self.recipesManager = recipesManager
        self.imageLoader = imageLoader
    }
}

extension RecipesViewModel {
    
    var navigationBarTitle: String { Localized.recipes.string }
    
    func refresh() {
        fetchRecipesData()
    }
    
    func viewModel(for item: Item) -> RecipeDetailsViewModel {
        generateHaptic(for: .recipeSelected)
        return RecipeDetailsViewModel(
            id: item.id,
            recipesManager: recipesManager,
            imageLoader: imageLoader
        )
    }
    
    func imageData(for item: Item) -> AnyPublisher<Data?, Never> {
        switch item {
        case let .recipe(recipe):
            return imageLoader.loadImage(for: recipe.thumbnail)
        }
    }
    
    private func fetchRecipesData() {
        Task {
            let recipes = await recipesManager.getRecipesList()
            DispatchQueue.main.async { [weak self] in
                self?.collectionGroups = [
                    CollectionGroup(
                        section: .main,
                        items: recipes.map { .recipe($0) }
                    )
                ]
            }
        }
    }
}

extension RecipesViewModel.Item {
    var id: RecipeID {
        switch self {
        case let .recipe(recipe):
            return recipe.id
        }
    }
}
