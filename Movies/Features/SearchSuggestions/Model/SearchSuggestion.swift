
//import Foundation
//
//struct SearchSuggestion: Identifiable {
//    let id = UUID()
//    let title: String
//}

import Foundation

struct SearchSuggestion: Hashable {
    let id = UUID()
    let title: String
}
