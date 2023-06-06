import Foundation

final class RecipesManager {
    private var localRecipesList = Set<RecipeModel>()
    private let service: APIServiceProtocol
    init(environment: Environment) {
        self.service = environment.services
    }
    
    // Fetch recipes from the local JSON file
    private func loadRecipes() async throws -> RecipesResponse {
        let data = try await service.loadData(for: .recipes)
        return try JSONDecoder().decode(RecipesResponse.self, from: data)
    }
    
    func getRecipesList(searchTerm: String = "") async -> [RecipeViewObject] {
        do {
            let recipesResponse = try await loadRecipes()
            localRecipesList = Set(recipesResponse.recipes)
        } catch {
            print("Log getRecipesList failure: \(error)")
        }
        return localRecipesList
            .filter { $0.contains(searchTerm) }
            .map(\.recipeViewObject)
            .sorted { $0.id < $1.id }
    }
    
    func getRecipeDetails(for id: RecipeID) async -> RecipeItemDetailsViewObject? {
        do {
            let recipesResponse = try await loadRecipes()
            localRecipesList = Set(recipesResponse.recipes)
        } catch {
            print("Log getRecipeDetails failure: \(error)")
        }
        return localRecipesList.first(where: { $0.id == id })?.itemDetailsViewObject
    }
}
