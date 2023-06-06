import UIKit

final class RecipeSpecsItemStackView: UIView {
    private var titleLabel = LabelFactory.build(
        font: DesignSystem.Font.subheading.uiFont,
        numberOfLines: 1
    )
    
    private var subtitleLabel = LabelFactory.build(
        font: DesignSystem.Font.heading.uiFont,
        numberOfLines: 1
    )
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecipeSpecsItemStackView {
    private func setupLayout() {
        addSubview(verticalStack)
        
        verticalStack.edgesToSuperview()
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
