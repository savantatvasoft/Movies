
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


protocol SearchSuggestionRepositoryProtocol {
    // CREATE
    func save(title: String)

    // READ
    func fetchAll() -> [SearchSuggestion]
    func filter(text: String) -> [SearchSuggestion]

    // UPDATE
    func update(id: UUID, newTitle: String)

    // DELETE
    func delete(id: UUID)
    func deleteAll()
}
