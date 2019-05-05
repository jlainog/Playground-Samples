import UIKit

let autolayoutStyle : (UIView) -> Void = {
    $0.translatesAutoresizingMaskIntoConstraints = false
}

func aspectRatioStyle(size: CGSize) -> (UIView) -> Void {
    return {
        $0.widthAnchor
            .constraint(equalTo: $0.heightAnchor,
                        multiplier: size.width / size.height)
            .isActive = true
    }
}

public let clockStyle: (UIView) -> Void = {
    $0.backgroundColor = .white
    }
    <> autolayoutStyle
    <> aspectRatioStyle(size: CGSize(width: 2, height: 1))

public let imageStyle: (UIView) -> Void =
    autolayoutStyle
        <> aspectRatioStyle(size: CGSize(width: 3, height: 2))

public let horizontalStyle: (UIView) -> Void = {
    $0.backgroundColor = .gray
    }
    <> autolayoutStyle
    <> aspectRatioStyle(size: CGSize(width: 3, height: 1))

public let rootStackViewStyle: (UIStackView) -> Void =
    autolayoutStyle
        <> {
            $0.axis = .vertical
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
            $0.spacing = 16
}
