enum Environment {
    case prod
    case test
    
    var apiHost: String {
        switch self {
        case .prod:
            return "https://coles.com.au/"
        case .test:
            return "https://coles.com.au/"
        }
    }
    
    var services: APIServiceProtocol {
        switch self {
        case .prod:
            return APIService()
        case .test:
            return APIServiceMock()
        }
    }
}
