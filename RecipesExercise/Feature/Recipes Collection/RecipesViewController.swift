import Combine
import UIKit

final class RecipesViewController: UIViewController, HapticGeneratable {
    typealias DataSource = UICollectionViewDiffableDataSource<RecipesViewModel.Section, RecipesViewModel.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<RecipesViewModel.Section, RecipesViewModel.Item>
    
    // Properties
    private var recipeListDataSource: DataSource!
    private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: RecipesViewController.recipesLayout
    )
    
    private let viewModel: RecipesViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(viewModel: RecipesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        setupSubviews()
        configureDataSource()
        setupObservers()
        
        loadData()
    }
}

extension RecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = recipeListDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let itemViewModel = viewModel.viewModel(for: item)
        let itemViewController = RecipesDetailsViewController(viewModel: itemViewModel)
        navigationController?.pushViewController(itemViewController, animated: true)
    }
}

private extension RecipesViewController {
    private func loadData() {
        viewModel.refresh()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = viewModel.navigationBarTitle        
    }
    
    private func setupObservers() {
        viewModel.$collectionGroups
            .removeDuplicates()
            .sink { [weak self] collection in
                DispatchQueue.main.async {
                    self?.applySnapshot(groups: collection)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupSubviews() {
        view.accessibilityIdentifier = ViewIdentifier.Recipes.recipesViewController.rawValue
        view.addSubview(collectionView)

        collectionView.delegate = self
        
        collectionView.register(
            RecipesCollectionViewCell.self,
            forCellWithReuseIdentifier: RecipesCollectionViewCell.reuseIdentifier
        )
        collectionView.edgesToSuperview()
        collectionView.accessibilityIdentifier = ViewIdentifier.Recipes.recipesCollectionView.rawValue
    }
    
    private func configureDataSource() {
        recipeListDataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [unowned self] (collectionView, indexPath, recipe) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecipesCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                cell.configure(item: recipe, viewModel: self.viewModel)
                return cell
            }
        )
    }
    
    private func applySnapshot(groups: [RecipesViewModel.CollectionGroup], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        for group in groups {
            snapshot.appendSections([group.section])
            snapshot.appendItems(group.items)
        }
        recipeListDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

private extension UICollectionViewCell {
    func configure(item: RecipesViewModel.Item, viewModel: RecipesViewModel) {
        switch item {
        case let .recipe(recipe):
            (self as! RecipesCollectionViewCell).configure(item: recipe, image: viewModel.imageData(for: item))
        }
    }
}

private extension RecipesViewController {
    enum Constants {
        static let collectionInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
    }
    
    static let recipesLayout: UICollectionViewLayout = {
        UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPortrait = layoutEnvironment.container.contentSize.width < layoutEnvironment.container.contentSize.height
            let columnsCount = isPortrait ? 1 : 2
            
            // Define Item Size
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            
            // Create Item
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Define Group Size
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: isPortrait ? .fractionalWidth(0.95) : .fractionalHeight(0.9)
            )
            
            // Create Group
            let interItemSpacing: CGFloat = 8
            let group = NSCollectionLayoutGroup.horizontal (layoutSize: groupSize, subitem: item, count: columnsCount)
            group.interItemSpacing = .fixed(interItemSpacing)
            
            // Create Section
            let section = NSCollectionLayoutSection(group: group)
            
            // Configure Section
            section.contentInsets = Constants.collectionInsets
            return section
        })
    }()
}

extension RecipesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}
