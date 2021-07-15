import SwiftUI

@main
struct FoodiesApp: App {
    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(\.managedObjectContext, DatabaseHelper.getInstance().container.viewContext)
        }
    }
    
}
