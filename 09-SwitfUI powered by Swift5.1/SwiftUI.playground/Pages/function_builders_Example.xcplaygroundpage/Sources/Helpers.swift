import Foundation
import UIKit

public func title(_ title: String) -> NSAttributedString {
    let font = UIFont.systemFont(ofSize: 72)
    let shadow = NSShadow()
    shadow.shadowColor = UIColor.gray
    shadow.shadowBlurRadius = 5
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: UIColor.black,
        .shadow: shadow
    ]
    
    return NSAttributedString(string: title, attributes: attributes)
}

public func subtitle(_ subtitle: String) -> NSAttributedString {
    let font = UIFont.systemFont(ofSize: 42)
    let shadow = NSShadow()
    shadow.shadowColor = UIColor.gray
    shadow.shadowBlurRadius = 5
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: UIColor.gray,
        .shadow: shadow
    ]
    
    return NSAttributedString(string: subtitle, attributes: attributes)
}

public var newLine: NSAttributedString { NSAttributedString(string: "\n") }

public func buildLabel(text: NSAttributedString) -> UILabel {
    let label = UILabel()
    label.attributedText = text
    label.numberOfLines = 0
    label.backgroundColor = .white
    label.frame.size = label.systemLayoutSizeFitting(
        CGSize(width: 300, height: 0),
        withHorizontalFittingPriority: .defaultHigh,
        verticalFittingPriority: .defaultLow
    )
    return label
}
