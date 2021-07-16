import SwiftUI

@main
struct FoodiesApp: App {
    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(\.managedObjectContext, DatabaseManager.getInstance().container.viewContext)
        }
    }
    
}
