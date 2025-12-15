import Foundation
import Combine

final class SearchSuggestionViewModel {

    @Published private(set) var suggestions: [SearchSuggestion] = []

    private let repository: SearchSuggestionRepositoryProtocol

    init(repository: SearchSuggestionRepositoryProtocol = SearchSuggestionRepository()) {
        self.repository = repository
//        showAll()
    }

    // MARK: - CREATE
    func saveSearch(text: String) {
        repository.save(title: text)
        showAll()
    }

    // MARK: - READ
    func showAll() {
        suggestions = repository.fetchAll()
    }

    func filter(text: String) {
        suggestions = text.isEmpty ? [] : repository.filter(text: text)
    }

    // MARK: - UPDATE
    func updateSuggestion(id: UUID, newText: String) {
        repository.update(id: id, newTitle: newText)
        showAll()
    }

    // MARK: - DELETE ONE
    func deleteSuggestion(id: UUID) {
        repository.delete(id: id)
        showAll()
    }

    // MARK: - DELETE ALL
    func clearHistory() {
        repository.deleteAll()
        suggestions = []
    }

    // MARK: - Helpers
    func numberOfItems() -> Int {
        suggestions.count
    }

    func item(at index: Int) -> SearchSuggestion {
        suggestions[index]
    }
}
