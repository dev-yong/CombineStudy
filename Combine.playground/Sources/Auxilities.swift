import Foundation

public func example(_ description: String,
                    action: () -> Void) {
  print("\n-----", description, "-----")
  action()
}

extension Notification.Name {
    public static let custom = Notification.Name("CustomNotification")
}
