import UIKit

final class RecipeSpecsView: UIView {
    private var amountSpecsStack = RecipeSpecsItemStackView()
    private var prepSpecsStack = RecipeSpecsItemStackView()
    private var cookingSpecsStack = RecipeSpecsItemStackView()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecipeSpecsView {
    func configure(specs: RecipeSpecsViewObject?) {
        guard let specs = specs else { return }
        amountSpecsStack.configure(
            title: specs.amountLabel,
            subtitle: "\(specs.amountNumber)"
        )
        
        prepSpecsStack.configure(
            title: specs.prepLabel,
            subtitle: specs.prepTime
        )
        
        cookingSpecsStack.configure(
            title: specs.cookingLabel,
            subtitle: specs.cookingTime
        )
    }
}

private extension RecipeSpecsView {
    private func setupLayout() {
        let firstDevider = deviderView()
        let secondDevider = deviderView()
        let stack = UIStackView(arrangedSubviews: [amountSpecsStack, firstDevider, prepSpecsStack, secondDevider, cookingSpecsStack])
        
        
        let topHorizontalLine = deviderView()
        let bottomHorizontalLine = deviderView()
        
        addSubview(topHorizontalLine)
        addSubview(bottomHorizontalLine)
        addSubview(stack)
        [topHorizontalLine, stack, bottomHorizontalLine].forEach {
            $0.edgesToSuperview(forEdge: .horizontal)
        }
        topHorizontalLine.edgesToSuperview(forEdge: .top)
        topHorizontalLine.bottomToTop(stack)
        stack.bottomToTop(bottomHorizontalLine)
        bottomHorizontalLine.edgesToSuperview(forEdge: .bottom)

        stack.distribution = .equalSpacing
        stack.alignment = .fill
        
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true

        
        NSLayoutConstraint.activate([
            firstDevider.heightAnchor.constraint(equalTo: amountSpecsStack.heightAnchor),
            secondDevider.heightAnchor.constraint(equalTo: amountSpecsStack.heightAnchor),
            firstDevider.widthAnchor.constraint(equalToConstant: 1),
            secondDevider.widthAnchor.constraint(equalToConstant: 1),
            
            topHorizontalLine.widthAnchor.constraint(equalTo: stack.widthAnchor),
            bottomHorizontalLine.widthAnchor.constraint(equalTo: stack.widthAnchor),
            topHorizontalLine.heightAnchor.constraint(equalToConstant: 1),
            bottomHorizontalLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func deviderView() -> UIView {
        let view = UIView()
        view.backgroundColor = DesignSystem.Color.secondary.uiColor
        return view
    }
}

