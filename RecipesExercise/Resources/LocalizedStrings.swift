import Foundation

enum Localized: String {
    case ingridients
    case recipe
    case recipes
    
    var string: String {
        NSLocalizedString(rawValue, comment: "\(rawValue) title")
    }
}
