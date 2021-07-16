import CoreData

struct DatabaseHelper {
    private static var inst:DatabaseHelper? = nil
    
    public static func getInstance() -> DatabaseHelper {
        if(inst == nil) {
            inst = DatabaseHelper()
        }
        
        return inst!;
    }
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "DatabaseModel")
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error \(error.localizedDescription)")
            }
        }
    }
    
    func getViewContext() -> NSManagedObjectContext {
        return container.viewContext;
    }
    
    func save() {
        let context = container.viewContext
        
        if(context.hasChanges) {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Error: \(error)")
            }
        }
    }
    
    func delete(object: NSManagedObject) {
        container.viewContext.delete(object)
        save()
    }
}
