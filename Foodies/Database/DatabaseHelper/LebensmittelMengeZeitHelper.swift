//
//  LebensmittelMengeHelper.swift
//  Foodies
//
//  Created by WJ on 14.07.21.
//

import Foundation
import SwiftUI
import CoreData

class LebensmittelMengeZeitHelper {
    /*
     mengeneinheit 1 = Angabe in g -> Kalorien pro 100g
     mengeneinheit 2 = Angabe in ml -> Kalorien pro 100ml
     mengeneinheit 3 = Angabe in Stück -> Kalorien pro Stück
     */
    
    public static func getKalorien(eintrag: LebensmittelMengeZeit) -> Int64 {
        return LebensmittelMengeHelper.getKalorien(kcal: eintrag.lebensmittel?.kcal ?? 0, menge: eintrag.menge, mengeneinheit: eintrag.lebensmittel?.mengeneinheit ?? 0)
    }
    
    public static func getComsumedCalories(day: Date, gesamtverlauf:FetchedResults<LebensmittelMengeZeit>) -> CGFloat {
        var kcals:CGFloat = 0;
        
        for verlauf in gesamtverlauf {
            if(Calendar.current.compare(day, to: verlauf.zeitpunkt!, toGranularity: .day) == ComparisonResult.orderedSame) {
                kcals += CGFloat(LebensmittelMengeHelper.getKalorien(kcal: verlauf.lebensmittel?.kcal ?? 0, menge: verlauf.menge, mengeneinheit: verlauf.lebensmittel?.mengeneinheit ?? 0))
            }
        }
        
        return kcals;
    }
}
