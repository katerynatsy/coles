import UIKit

extension UIView {
    enum Edge: CaseIterable {
        case top
        case left
        case bottom
        case right
        
        case all
        case horizontal
        case vertical
        
        var cases: [Edge] {
            switch self {
            case .all:
                return Edge.allCases
            case .horizontal:
                return [.left, .right]
            case .vertical:
                return [.top, .bottom]
            default:
                return [self]
            }
        }
    }
    
    func edgesToSuperview(
        forEdge edge: Edge = .all,
        with insets: UIEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
    ) {
        edgesToSuperview(
            forEdges: edge.cases,
            with: insets
        )
    }
    
    func edgesToSuperview(
        forEdges edges: [Edge],
        with insets: UIEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
    ) {
        guard let superview = superview else {
            fatalError("\(description) has no superview")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let basicEdges = Set(edges.flatMap(\.cases))
        
        basicEdges.forEach { edge in
            switch edge {
            case .top:
                topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
            case .left:
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
            case .right:
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
            default:
                return
            }
        }
    }
    
    func bottomToTop(_ view: UIView, spacing: CGFloat = 0) {
        bottomAnchor.constraint(equalTo: view.topAnchor, constant: spacing).isActive = true
    }
}
