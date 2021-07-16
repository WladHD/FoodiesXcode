import Foundation
import SwiftUI
import CoreData

class BMIHelper {
    public static func getClosestDateBelow(day: Date, gesamtverlauf:FetchedResults<BMIVerlauf>) -> BMIVerlauf? {

        for bmieintrag in gesamtverlauf {
            if(Calendar.current.compare(day, to: bmieintrag.zeitpunkt!, toGranularity: .day) != ComparisonResult.orderedAscending) {
                return bmieintrag;
            }
        }
        
        return nil;
    }
}
