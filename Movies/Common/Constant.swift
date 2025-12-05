
import UIKit

enum Screen {
    
    // Safe replacement for UIScreen.main
    private static var currentScreen: UIScreen? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .screen
    }
    
    static var width: CGFloat {
        currentScreen?.bounds.width ?? 0
    }
    
    static var height: CGFloat {
        currentScreen?.bounds.height ?? 0
    }
}
