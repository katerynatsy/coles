import Combine
import UIKit

final class RecipesDetailsViewController: UIViewController {
    private let viewModel: RecipeDetailsViewModel
    
    private var titleLabel = LabelFactory.build(
        font: DesignSystem.Font.largeTitle.uiFont
    )
    
    private var descriptionLabel = LabelFactory.build(
        font: DesignSystem.Font.subheading.uiFont
    )
    
    private var thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var specsView = RecipeSpecsView()
    
    private var ingridientsTitleLabel = LabelFactory.build(
        font: DesignSystem.Font.title.uiFont,
        textAlignment: .left
    )
    
    private var ingridientsListLabel = LabelFactory.build(
        font: DesignSystem.Font.body.uiFont,
        textAlignment: .left
    )
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = DesignSystem.Color.background.uiColor
        setupObservers()
        fetchData()
        setupLayout()
    }
}

private extension RecipesDetailsViewController {
    func fetchData() {
        viewModel.fetchRecipeDetailsData()
    }
    
    func setupLayout() {
        let scrollView = UIScrollView()
        let scrollViewContainer = UIStackView(
            arrangedSubviews: [
                titleLabel,
                descriptionLabel,
                thumbnailView,
                specsView,
                ingridientsTitleLabel,
                ingridientsListLabel
            ]
        )
        scrollViewContainer.axis = .vertical
        scrollViewContainer.alignment = .center
        scrollViewContainer.spacing = 16
        scrollViewContainer.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        scrollViewContainer.isLayoutMarginsRelativeArrangement = true
                
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollView.edgesToSuperview()

        scrollViewContainer.edgesToSuperview()        
        ingridientsTitleLabel.text = viewModel.ingridientsTitle
                
        NSLayoutConstraint.activate([
            thumbnailView.heightAnchor.constraint(
                equalTo: thumbnailView.widthAnchor,
                multiplier: RecipesCollectionViewCell.Constant.imageRatio
            ),
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: scrollViewContainer.leadingAnchor, constant: 64),
            titleLabel.centerXAnchor.constraint(equalTo: scrollViewContainer.centerXAnchor),
            
            descriptionLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: scrollViewContainer.leadingAnchor,
                constant: 32
            ),
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollViewContainer.centerXAnchor),
            
            specsView.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor),
            ingridientsTitleLabel.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor),
            ingridientsListLabel.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor)
        ])
        
        configureAccessibilityIdentifiers()
    }
    
    func setupObservers() {
        viewModel.titlePublisher
            .assignOnUIThread(to: \.text, onWeak: titleLabel)
            .store(in: &cancellables)
        
        viewModel.descriptionPublisher
            .assignOnUIThread(to: \.text, onWeak: descriptionLabel)
            .store(in: &cancellables)

        viewModel.recipeSpecsPublisher
            .sink { [weak self] recipeSpecs in
                DispatchQueue.main.async {
                    self?.specsView.configure(specs: recipeSpecs)
                }
            }
            .store(in: &cancellables)
        
        viewModel.ingridientsPublisher
            .compactMap { [weak self] ingridients in
                guard let ingridients = ingridients else { return nil }
                return self?.formatIngridientsString(ingridients)
            }
            .assignOnUIThread(to: \.attributedText, onWeak: ingridientsListLabel)
            .store(in: &cancellables)
        
        viewModel.imageLabel
            .assignOnUIThread(to: \.accessibilityLabel, onWeak: thumbnailView)
            .store(in: &cancellables)
        
        viewModel.imagePublisher
            .compactMap { $0 }
            .sink { [weak self] data in
                guard let self = self else { return }
                
                UIView.transition(
                    with: self.thumbnailView,
                    duration: 0.3,
                    options: .curveEaseIn,
                    animations: {
                        DispatchQueue.main.async {
                            self.thumbnailView.image = UIImage(data: data)
                        }
                    },
                    completion: nil
                )
            }
            .store(in: &cancellables)
    }
    
    func configureAccessibilityIdentifiers() {
        view.accessibilityIdentifier = ViewIdentifier.RecipeDetails.recipeDetailsBackButtonLabel.rawValue
        navigationController?.navigationBar.accessibilityIdentifier = ViewIdentifier.RecipeDetails.recipeDetailsNavigationBar.rawValue
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = ViewIdentifier.RecipeDetails.recipeDetailsBackButtonLabel.rawValue
        titleLabel.accessibilityIdentifier = ViewIdentifier.RecipeDetails.recipeDetailsTitleLable.rawValue
        descriptionLabel.accessibilityIdentifier = ViewIdentifier.RecipeDetails.recipeDetailsDescriptionLabel.rawValue
        thumbnailView.accessibilityIdentifier = ViewIdentifier.RecipeDetails.recipeDetailsThumbnailView.rawValue
        specsView.accessibilityIdentifier = ViewIdentifier.RecipeDetails.recipeDetailsRecipeSpecs.rawValue
        ingridientsTitleLabel.accessibilityIdentifier = ViewIdentifier.RecipeDetails.recipeDetailsIngridientsTitleLabel.rawValue
        ingridientsListLabel.accessibilityIdentifier = ViewIdentifier.RecipeDetails.recipeDetailsIngridientsListLabel.rawValue
    }
    
    func formatIngridientsString(_ ingridients: String) -> NSAttributedString {
        let listParagraphStyle = NSMutableParagraphStyle()
        let bulletSize = NSAttributedString(string: ">    ", attributes: [.font: UIFont.preferredFont(forTextStyle: .body)]).size()
        let itemStart = bulletSize.width
        listParagraphStyle.headIndent = itemStart
        listParagraphStyle.paragraphSpacing = 8

        let listAttributedString = NSAttributedString(string: ingridients, attributes: [
            .paragraphStyle: listParagraphStyle,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ])
        return listAttributedString
    }
}
