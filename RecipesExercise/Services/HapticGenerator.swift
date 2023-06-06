import UIKit

enum HapticAppAction {
    case recipeSelected
    case backButtonTapped

    var hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .recipeSelected, .backButtonTapped:
            return .medium
        }
    }
}

protocol HapticGeneratable: AnyObject {
    func generateHaptic(for action: HapticAppAction)
}

extension HapticGeneratable {
    func generateHaptic(for action: HapticAppAction) {
        let generator = UIImpactFeedbackGenerator(style: action.hapticStyle)
        generator.impactOccurred()
    }
}
