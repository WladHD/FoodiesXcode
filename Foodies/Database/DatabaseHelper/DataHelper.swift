//
//  DataHelper.swift
//  Foodies
//
//  Created by WJ on 14.07.21.
//

import Foundation
import CoreData


class DataHelper {
    public static func save(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Error: \(error)")
        }
    }
}
