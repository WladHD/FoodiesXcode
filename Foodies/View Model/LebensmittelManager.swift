import Foundation
import CoreData

class LebensmittelManager: ObservableObject {
    
    /*
     ADD / DELETE
     */
    func deleteLebensmittelMenge(lm: LebensmittelMenge) {
        DatabaseManager.getInstance().delete(object: lm)
    }
    
    func saveLebensmittelMengeZeit(lebensmittel: Lebensmittel, menge: String) -> String? {
        let eMenge = isConvertableToInt64(obj: menge, objName: "Menge")
        
        if(eMenge != nil) {
            return eMenge!
        }
        
        saveLebensmittelMengeZeit(lebensmittel: lebensmittel, menge: Int64(menge)!)
        
        return nil;
    }
    
    func saveLebensmittelMengeZeit(lebensmittel: Lebensmittel, menge: Int64) {
        let newLebensmittelMengeZeit = LebensmittelMengeZeit(context: DatabaseManager.getInstance().getViewContext())
        newLebensmittelMengeZeit.lebensmittel = lebensmittel;
        newLebensmittelMengeZeit.menge = menge;
        newLebensmittelMengeZeit.zeitpunkt = Date()
        
        DatabaseManager.getInstance().save()
    }
    
    func saveLebensmittelMenge(lebensmittel: Lebensmittel, menge: String) -> String? {
        let eMenge = isConvertableToInt64(obj: menge, objName: "Menge")
        
        if(eMenge != nil) {
            return eMenge!
        }
        
        saveLebensmittelMenge(lebensmittel: lebensmittel, menge: Int64(menge)!)
        
        return nil;
    }
    
    func saveLebensmittelMenge(lebensmittel: Lebensmittel, menge: Int64) {
        let newLebensmittelMenge = lebensmittel.ernaehrungsplan == nil ? LebensmittelMenge(context: DatabaseManager.getInstance().getViewContext()) : lebensmittel.ernaehrungsplan!;
        
        if(lebensmittel.ernaehrungsplan == nil) {
            newLebensmittelMenge.lebensmittel = lebensmittel;
            newLebensmittelMenge.menge = menge
        } else {
            newLebensmittelMenge.menge += menge
        }
        
        DatabaseManager.getInstance().save()
    }
    
    func saveLebensmittel(name: String, kcal: String, mengeneinheit: Int64) -> String? {
        var err = isAllowedString(obj: kcal, objName: "Name")
        
        if(err != nil) {
            return err!
        }
        
        err = isConvertableToInt64(obj: kcal, objName: "Kalorien")
        
        if(err != nil) {
            return err!
        }
        
        saveLebensmittel(name: name, kcal: Int64(kcal)!, mengeneinheit: mengeneinheit)
        
        return nil
    }
    
    func saveLebensmittel(name: String, kcal: Int64, mengeneinheit: Int64) {
        var lebensmittelPreselect:Lebensmittel? = parseLebensmittelByName(pName: name)
        
        if(lebensmittelPreselect == nil) {
            lebensmittelPreselect = Lebensmittel(context: DatabaseManager.getInstance().getViewContext());
        }
        
        lebensmittelPreselect?.name = name;
        lebensmittelPreselect?.kcal = kcal;
        lebensmittelPreselect?.mengeneinheit = mengeneinheit + 1;
        
        DatabaseManager.getInstance().save()
    }
    
    func saveBMIHistory(gewicht: String, groesse: String) -> String? {
        var err = isConvertableToInt64(obj: groesse, objName: "Größe")
        
        if(err != nil) {
            return err!
        }
        
        err = isConvertableToDouble(obj: gewicht, objName: "Gewicht")
        
        if(err != nil) {
            return err!
        }
        
        saveBMIHistory(gewicht: Double(gewicht)!, groesse: Int64(groesse)!)
        
        return nil
    }
    
    func saveBMIHistory(gewicht: Double, groesse: Int64) {
        let bmiEintrag = BMIVerlauf(context: DatabaseManager.getInstance().getViewContext());
        bmiEintrag.gewicht = gewicht
        bmiEintrag.groesse = groesse
        bmiEintrag.zeitpunkt = Date()
        
        DatabaseManager.getInstance().save()
    }
    
    
    
    /*
     REQUESTS
     */
    func requestLebensmittelMengeZeit() -> [LebensmittelMengeZeit] {
        do {
            return try DatabaseManager.getInstance().getViewContext().fetch(LebensmittelMengeZeit.fetchRequest())
        } catch {
            
        }
        
        return []
    }
    
    func requestLebensmittel() -> [Lebensmittel] {
        do {
            return try DatabaseManager.getInstance().getViewContext().fetch(Lebensmittel.fetchRequest())
        } catch {
            
        }
        
        return []
    }
    
    /*
     LOGIC
     */
    private func parseLebensmittelByName(pName: String) -> Lebensmittel? {
        for lm in requestLebensmittel() {
            if(pName.compare(lm.name!, options: .caseInsensitive) == ComparisonResult.orderedSame) {
                return lm;
            }
        }
        
        return nil;
    }
    
    func isConvertableToInt64(obj: String, objName: String) -> String? {
        if(obj.count == 0) {
            return "\(objName) darf nicht leer sein"
        }
        
        if(Int64(obj) == nil) {
            return "\(objName) muss eine Zahl sein"
        }
        
        if(Int64(obj)! <= 0) {
            return "\(objName) muss größer als 0 sein"
        }
        
        return nil
    }
    
    func isConvertableToDouble(obj: String, objName: String) -> String? {
        if(obj.count == 0) {
            return "\(objName) darf nicht leer sein"
        }
        
        if(Double(obj) == nil) {
            return "\(objName) muss eine Fließkommazahl sein"
        }
        
        if(Double(obj)! <= 0) {
            return "\(objName) muss größer als 0 sein"
        }
        
        return nil
    }
    
    func isAllowedString(obj: String, objName: String) -> String? {
        if(obj.count == 0) {
            return "\(objName) darf nicht leer sein"
        }
        
        return nil
    }
    
    func isAllowedToEat(lm: Lebensmittel) -> AllowedFood? {
        let menge:Int64 = lm.ernaehrungsplan!.menge - getEatenToday(lm: lm);
        
        if(menge <= 0) {
            return nil;
        }
        
        return AllowedFood(
            name: lm.name!,
            menge: menge,
            einheit: LebensmittelHelper.getEinheit(lebensmittel: lm),
            kcal: LebensmittelMengeHelper.getCustomKalorien(lebensmittel: lm, menge: menge)
        )
    }
    
    func getEatenToday(lm: Lebensmittel) -> Int64 {
        var menge:Int64 = 0;
        
        for eintrag in requestLebensmittelMengeZeit() {
            if(eintrag.lebensmittel == lm && Calendar.current.compare(eintrag.zeitpunkt!, to: Date(), toGranularity: .day) == ComparisonResult.orderedSame) {
                menge += eintrag.menge;
            }
        }
        
        return menge;
    }
}
