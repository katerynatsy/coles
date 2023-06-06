import Combine
import Foundation

public extension Publisher where Failure == Never {
    func assignOnUIThread<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, onWeak object: Root) -> AnyCancellable {
        receive(on: DispatchQueue.main)
            .sink { [weak object] value in
                object?[keyPath: keyPath] = value
            }
    }
}
