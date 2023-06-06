import Combine
import UIKit

protocol ImageLoaderProtocol {
    func loadImage(for path: String) -> AnyPublisher<Data?, Never>
}

final class ImageLoader: ImageLoaderProtocol {
    private let baseUrl: URL?
    private let imageCache = NSCache<NSString, NSData>()

    init(envioronment: Environment = .prod) {
        self.baseUrl = URL(string: envioronment.apiHost)
    }
    
    func loadImage(for path: String) -> AnyPublisher<Data?, Never> {
        if let imageData = imageCache.object(forKey: path as NSString) {
            return Just(imageData as Data).eraseToAnyPublisher()
        }
        
        guard let url = baseUrl?.appendingPathComponent(path) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[weak self] imageData in
                guard let imageData = imageData else { return }
                self?.imageCache.setObject(imageData as NSData, forKey: path as NSString)
            })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

final class MockImageLoader: ImageLoaderProtocol {
    private var mockImagePublisher: AnyPublisher<Data?, Never> {
        Just(UIImage(systemName: "photo")?.jpegData(compressionQuality: 0.5))
            .eraseToAnyPublisher()
    }
    
    func loadImage(for path: String) -> AnyPublisher<Data?, Never> {
        return mockImagePublisher
    }
}
