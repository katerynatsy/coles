import UIKit

struct LabelFactory {
    static func build(
        text: String? = nil,
        font: UIFont,
        numberOfLines: Int = 0,
        backgroundColor: UIColor = .clear,
        textColor: UIColor = DesignSystem.Color.text.uiColor,
        textAlignment: NSTextAlignment = .center
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.numberOfLines = numberOfLines
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.textAlignment = textAlignment
        return label
    }
}
