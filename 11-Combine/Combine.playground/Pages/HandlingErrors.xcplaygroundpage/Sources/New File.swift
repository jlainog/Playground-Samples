import Foundation

extension Notification.Name {
   public static let newTrick = Notification.Name("NewTrick")
}

public struct MagicTrick: Codable {
    public static var placeHolder = MagicTrick(name: "default", kind: "default")
    
    public var name: String
    public var kind: String
}
