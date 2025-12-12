import Foundation
import Combine

final class SearchSuggestionViewModel {

    @Published private(set) var suggestions: [SearchSuggestion] = []

    private var allSuggestions: [SearchSuggestion] = [
        SearchSuggestion(title: "Iron Man"),
        SearchSuggestion(title: "Avengers"),
        SearchSuggestion(title: "Spider Man"),
        SearchSuggestion(title: "Batman"),
        SearchSuggestion(title: "Superman"),
        SearchSuggestion(title: "Thor"),
        SearchSuggestion(title: "Hulk"),
        SearchSuggestion(title: "Black Panther"),
        SearchSuggestion(title: "Doctor Strange"),
        SearchSuggestion(title: "Captain America"),
        SearchSuggestion(title: "Wonder Woman"),
        SearchSuggestion(title: "Aquaman")
    ]

    func filter(text: String) {
        if text.isEmpty {
            suggestions = []
        } else {
            suggestions = allSuggestions.filter {
                $0.title.lowercased().contains(text.lowercased())
            }
        }
    }

    func showAll() {
        suggestions = allSuggestions
    }

    func numberOfItems() -> Int {
        suggestions.count
    }

    func item(at index: Int) -> SearchSuggestion {
        suggestions[index]
    }
}
