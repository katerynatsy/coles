import UIKit

struct DesignSystem {
    enum Font {
        case heading // 23 heavy
        case subheading // 21 semi bold
        case body // 23 regular
        case largeTitle // 40 heavy
        case title // 34 heavy

        var uiFont: UIFont {
            switch self {
            case .heading:
                return UIFont.preferredFont(forTextStyle: .headline)
                    .with(weight: .heavy)
            case .subheading:
                return UIFont.preferredFont(forTextStyle: .subheadline)
            case .body:
                return UIFont.preferredFont(forTextStyle: .body)
            case .largeTitle:
                return UIFont.preferredFont(forTextStyle: .largeTitle)
                    .with(weight: .heavy)
            case .title:
                return UIFont.preferredFont(forTextStyle: .title1)
                    .with(weight: .heavy)
            }
        }
    }

    enum Color {
        case primary
        case secondary
        case background
        case text

        var uiColor: UIColor {
            switch self {
            case .primary:
                return UIColor(named: "Color/AccentColor") ?? .systemRed
            case .secondary:
                return UIColor(named: "Color/Secondary") ?? .systemRed
            case .text:
                return UIColor(named: "Color/Text") ?? .systemGray2
            case .background:
                return UIColor(named: "Color/Backgroung") ?? .systemBackground
            }
        }
    }
}

extension UIFont {
    func with(weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}
