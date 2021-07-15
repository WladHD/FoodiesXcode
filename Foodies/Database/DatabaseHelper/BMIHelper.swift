//
//  BMIHelper.swift
//  Foodies
//
//  Created by WJ on 15.07.21.
//

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
