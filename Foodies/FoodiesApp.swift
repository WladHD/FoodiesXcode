//
//  FoodiesApp.swift
//  Foodies
//
//  Created by WJ on 14.07.21.
//

import SwiftUI

@main
struct FoodiesApp: App {
    let persistanceContainer = PersistanceContainer.shared
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(\.managedObjectContext, persistanceContainer.container.viewContext)
        }
    }
}
