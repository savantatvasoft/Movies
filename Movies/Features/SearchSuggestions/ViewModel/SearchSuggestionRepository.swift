import CoreData

final class SearchSuggestionRepository: SearchSuggestionRepositoryProtocol {

    private let manager = CoreDataManager.shared

    // MARK: - CREATE
    func save(title: String) {
        print("save trigger with \(title)")
        let context = manager.viewContext

        // Avoid duplicates
        let request: NSFetchRequest<SavedMovies> = SavedMovies.fetchRequest()
        request.predicate = NSPredicate(format: "title ==[c] %@", title)

        if let count = try? context.count(for: request), count > 0 {
            return
        }

        let entity = SavedMovies(context: context)
        entity.id = UUID()
        entity.title = title
        entity.date = Date()

        manager.save()
    }

    // MARK: - READ ALL
    func fetchAll() -> [SearchSuggestion] {
        let request: NSFetchRequest<SavedMovies> = SavedMovies.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]

        let result = (try? manager.viewContext.fetch(request)) ?? []
        return result.map { SearchSuggestion(title: $0.title ?? "") }
    }

    // MARK: - FILTER
    func filter(text: String) -> [SearchSuggestion] {
        let request: NSFetchRequest<SavedMovies> = SavedMovies.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)

        let result = (try? manager.viewContext.fetch(request)) ?? []
        return result.map { SearchSuggestion(title: $0.title ?? "") }
    }

    // MARK: - UPDATE
    func update(id: UUID, newTitle: String) {
        let request: NSFetchRequest<SavedMovies> = SavedMovies.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let entity = try? manager.viewContext.fetch(request).first else { return }

        entity.title = newTitle
        entity.date = Date()

        manager.save()
    }

    // MARK: - DELETE ONE
    func delete(id: UUID) {
        let request: NSFetchRequest<SavedMovies> = SavedMovies.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        if let entity = try? manager.viewContext.fetch(request).first {
            manager.viewContext.delete(entity)
            manager.save()
        }
    }

    // MARK: - DELETE ALL
    func deleteAll() {
        let request: NSFetchRequest<NSFetchRequestResult> =
        SavedMovies.fetchRequest()

        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
        try? manager.container.persistentStoreCoordinator.execute(
            batchDelete,
            with: manager.viewContext
        )
    }
}
