import SwiftUI

struct TagesberichtView: View {
    @ObservedObject
    var lebensmittelManager: LebensmittelManager
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "zeitpunkt", ascending: false)])
    private var gesamtverlaufMengeZeit: FetchedResults<LebensmittelMengeZeit>
    
    @FetchRequest(sortDescriptors: [])
    private var ernaehrungsplan: FetchedResults<LebensmittelMenge>
    
    var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
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
                                let af:AllowedFood? = lebensmittelManager.isAllowedToEat(lm: ep.lebensmittel!)
                                
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
}

struct TagesberichtView_Previews: PreviewProvider {
    static var previews: some View {
        TagesberichtView(lebensmittelManager: LebensmittelManager())
    }
}
