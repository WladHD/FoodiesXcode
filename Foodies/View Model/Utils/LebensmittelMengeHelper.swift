import Foundation
import SwiftUI
import CoreData

class LebensmittelMengeHelper {
    /*
     mengeneinheit 1 = Angabe in g -> Kalorien pro 100g
     mengeneinheit 2 = Angabe in ml -> Kalorien pro 100ml
     mengeneinheit 3 = Angabe in Stück -> Kalorien pro Stück
     */
    public static func getKalorien(eintrag: LebensmittelMenge) -> Int64 {
        return getKalorien(kcal: eintrag.lebensmittel?.kcal ?? 0, menge: eintrag.menge, mengeneinheit: eintrag.lebensmittel?.mengeneinheit ?? 0)
    }
    
    public static func getKalorienSumme(ernaehrungsplan: FetchedResults<LebensmittelMenge>) -> Int64 {
        var kcal:Int64 = 0;
        
        for eintrag in ernaehrungsplan {
            kcal += getKalorien(eintrag: eintrag)
        }
        
        return kcal;
    }
    
    public static func getKalorien(kcal: Int64, menge: Int64, mengeneinheit: Int64) -> Int64 {
        return kcal * menge / LebensmittelHelper.getEinheitDivisor(mengeneinheit: mengeneinheit)
    }
    
    public static func getCustomKalorien(lebensmittel: Lebensmittel, menge:Int64) -> Int64 {
        return lebensmittel.kcal * menge / LebensmittelHelper.getEinheitDivisor(mengeneinheit: lebensmittel.mengeneinheit);
    }
    
    public static func getGesamtkalorien(ernaehrungsplan:FetchedResults<LebensmittelMenge>) -> CGFloat {
        var kcal:CGFloat = 0
        
        for eintrag in ernaehrungsplan {
            kcal += CGFloat(getKalorien(eintrag: eintrag))
        }
        
        return kcal;
    }
}
