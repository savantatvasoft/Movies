
import UIKit

enum BorderSide {
    case top
    case bottom
    case left
    case right
}

extension UIView {

    func addBorder(sides: [BorderSide], color: UIColor = .black, borderWidth: CGFloat = 1.0) {

        // Remove old borders (avoid duplicates)
        layer.sublayers?.removeAll(where: { $0.name == "UIViewBorder" })

        for side in sides {
            let border = CALayer()
            border.name = "UIViewBorder"
            border.backgroundColor = color.cgColor

            switch side {
            case .top:
                border.frame = CGRect(x: 0,
                                      y: 0,
                                      width: bounds.width,
                                      height: borderWidth)

            case .bottom:
                border.frame = CGRect(x: 0,
                                      y: bounds.height - borderWidth,
                                      width: bounds.width,
                                      height: borderWidth)

            case .left:
                border.frame = CGRect(x: 0,
                                      y: 0,
                                      width: borderWidth,
                                      height: bounds.height)

            case .right:
                border.frame = CGRect(x: bounds.width - borderWidth,
                                      y: 0,
                                      width: borderWidth,
                                      height: bounds.height)
            }

            layer.addSublayer(border)
        }
    }
}
