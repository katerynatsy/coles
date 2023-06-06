import Combine
import UIKit

final class RecipesCollectionViewCell: UICollectionViewCell {
    enum Constant {
        static let imageRatio: CGFloat = 288/480
    }
    
    static let reuseIdentifier = String(describing: RecipesCollectionViewCell.self)
    
    private var thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = DesignSystem.Color.secondary.uiColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var titleLabel: UILabel = LabelFactory.build(
        font: DesignSystem.Font.heading.uiFont,
        textColor: DesignSystem.Color.primary.uiColor
    )
    
    private var subtitleLabel: UILabel = LabelFactory.build(
        font: DesignSystem.Font.body.uiFont,
        numberOfLines: 2,
        textAlignment: .left
    )
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailView.image = nil
        thumbnailView.accessibilityLabel = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        cancellables = []
    }
}

extension RecipesCollectionViewCell {
    func configure(item: RecipeViewObject, image: AnyPublisher<Data?, Never>) {
        titleLabel.text = item.title.uppercased()
        subtitleLabel.text = item.description
        thumbnailView.accessibilityLabel = item.imageLabel
        
        image
            .compactMap { $0 }
            .sink { [weak self] data in
                guard let self = self else { return }
                
                UIView.transition(
                    with: self.thumbnailView,
                    duration: 0.3,
                    options: .curveEaseIn,
                    animations: {
                        DispatchQueue.main.async {
                            self.thumbnailView.image = UIImage(data: data) }
                    },
                    completion: nil
                )
            }
            .store(in: &cancellables)
    }
    
    private func setupLayout() {
        let container = UIStackView(arrangedSubviews: [thumbnailView, titleLabel, subtitleLabel, UIView()])
        container.axis = .vertical
        container.alignment = .leading
        container.setCustomSpacing(8, after: thumbnailView)
        contentView.addSubview(container)
        container.edgesToSuperview()
        
        NSLayoutConstraint.activate([
            thumbnailView.heightAnchor.constraint(equalTo: thumbnailView.widthAnchor, multiplier: Constant.imageRatio),
            titleLabel.heightAnchor.constraint(equalToConstant: UIFont.preferredFont(forTextStyle: .title1).lineHeight)
        ])
    }
}
