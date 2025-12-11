
import Foundation
import UIKit
import Combine

extension UITextField {
    
    func setLeftIcon(_ icon: UIImage, padding: CGFloat = 8) {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 30 + padding, height: 40))
        let iconView = UIImageView(image: icon)
        iconView.tintColor = .gray
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: padding, y: 0, width: 20, height: 40)
        container.addSubview(iconView)
        leftView = container
        leftViewMode = .always
        
    }
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .handleEvents(receiveOutput: { notification in
              print("🟦 Notification received: \(notification)")
          })
        .compactMap { ($0.object as? UITextField)?.text }
        .map { text -> String in
                print("🔍 User typed: \(text)")
                return text
            }
        .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
        .removeDuplicates()
        .handleEvents(receiveOutput: { text in
            print("🔍 Search Text: \(text)")
        })
        .eraseToAnyPublisher()
    }


}
