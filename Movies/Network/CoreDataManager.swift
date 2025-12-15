import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    // MARK: - Persistent Container
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure("❌ Core Data error: \(error)")
            }
        }
        return container
    }()

    // MARK: - Contexts
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    func backgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    // MARK: - Save
    func save(context: NSManagedObjectContext? = nil) {
        
        print("save manger trigger")
        let context = context ?? viewContext
        guard context.hasChanges else { return }

        do {
           let value =  try context.save()
        } catch {
            print("❌ Save error:", error)
        }
    }
}
