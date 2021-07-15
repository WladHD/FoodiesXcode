import SwiftUI

struct TagesberichtView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "zeitpunkt", ascending: false)])
    private var gesamtverlaufMengeZeit: FetchedResults<LebensmittelMengeZeit>
    
    @FetchRequest(sortDescriptors: [])
    private var ernaehrungsplan: FetchedResults<LebensmittelMenge>
    
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    @State private var refreshID = UUID()
    
    var body : some View {
        NavigationView {
            ZStack(alignment: .top) {
                BackgroundView()
                
                VStack(spacing: 50) {
                    ProgressBarExtended(curKalorien: LebensmittelMengeZeitHelper.getComsumedCalories(day: Date(), gesamtverlauf: gesamtverlaufMengeZeit), maxKalorien: LebensmittelMengeHelper.getGesamtkalorien(ernaehrungsplan: ernaehrungsplan))
                    
                    List {
                        Section(header: Text("Was kann ich noch essen?")) {
                            ForEach(ernaehrungsplan) { ep in
                                let af:AllowedFood? = allowedToEat(lm: ep.lebensmittel!)
                                
                                if(af != nil) {
                                    
                                    LebensmittelRowView(
                                        menge: af!.menge,
                                        einheit: af!.einheit,
                                        name: af!.name,
                                        kalorien: af!.kcal
                                    )
                                    
                                    
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .listStyle(GroupedListStyle())
                    .id(refreshID)
                    .onReceive(self.didSave) { _ in
                        self.refreshID = UUID()
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Tagesbericht")
        }
    }
    
    struct AllowedFood {
        var name:String
        var menge:Int64
        var einheit:String
        var kcal:Int64
    }
    
    private func allowedToEat(lm: Lebensmittel) -> AllowedFood? {
        let menge:Int64 = lm.ernaehrungsplan!.menge - eatenToday(lm: lm);
        
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
    
    private func eatenToday(lm: Lebensmittel) -> Int64 {
        var menge:Int64 = 0;
        
        for eintrag in gesamtverlaufMengeZeit {
            if(eintrag.lebensmittel == lm && Calendar.current.compare(eintrag.zeitpunkt!, to: Date(), toGranularity: .day) == ComparisonResult.orderedSame) {
                menge += eintrag.menge;
            }
        }
        
        return menge;
    }
}

struct TagesberichtView_Previews: PreviewProvider {
    static var previews: some View {
        TagesberichtView()
    }
}
