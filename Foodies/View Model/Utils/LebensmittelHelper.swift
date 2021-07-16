import Foundation
import CoreData

class LebensmittelHelper {
    public static var kalProEinheitFormat = ["kcal pro 100g", "kcal pro 100ml", "kcal pro Stück"];
    
    public static func getEinheitDivisor(mengeneinheit: Int64) -> Int64 {
        return (mengeneinheit != 3 ? 100 : 1)
    }
    
    public static func getEinheit(lebensmittel: Lebensmittel) -> String {
        return getEinheit(mengeneinheit: lebensmittel.mengeneinheit)
    }
    
    public static func getEinheit(mengeneinheit: Int64) -> String {
        switch mengeneinheit {
        case 1:
            return "g"
        case 2:
            return "ml"
        case 3:
            return " Stück"
        default:
            break
        }
        
        return "Fehler"
    }
    
    public static func getKalProEinheitFormat(lebensmittel: Lebensmittel) -> String {
        return getKalProEinheitFormat(mengeneinheit: lebensmittel.mengeneinheit)
    }
    
    public static func getKalProEinheitFormat(mengeneinheit: Int64) -> String {
        switch mengeneinheit {
        case 1:
            return "pro 100g"
        case 2:
            return "pro 100ml"
        case 3:
            return "pro Stück"
        default:
            break
        }
        
        return "Fehler"
    }
}


