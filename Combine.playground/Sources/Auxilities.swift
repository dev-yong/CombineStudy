import Foundation
import Combine

public func example(_ description: String,
                    action: () -> Void) {
  print("\n-----", description, "-----")
  action()
}

extension Notification.Name {
    public static let custom = Notification.Name("CustomNotification")
}

public enum CustomError: LocalizedError {
    case custom(description: String)
    
    public var errorDescription: String? {
        switch self {
        case .custom(let description):
            return description
        }
    }
}

public var cancellableBag = Set<AnyCancellable>()
