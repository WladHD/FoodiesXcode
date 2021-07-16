import SwiftUI

struct ErnaehrungsplanView: View {
    @ObservedObject
    var lebensmittelManager: LebensmittelManager
    
    @FetchRequest(sortDescriptors: [])
    private var ernaehrungsplan: FetchedResults<LebensmittelMenge>
    
    var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    @State private var refreshID = UUID()
    
    var body : some View {
        NavigationView {
            ZStack(alignment: .top) {
                BackgroundView()
                
                VStack(spacing: 50) {
                    ProgressBarExtended(maxKalorien: CGFloat(LebensmittelMengeHelper.getKalorienSumme(ernaehrungsplan: ernaehrungsplan)))
                    
                    List {
                        Section(header: Text("Mein Ernährungsplan")) {
                            ForEach(ernaehrungsplan) { eintrag in
                                LebensmittelRowView(
                                    menge: eintrag.menge,
                                    einheit: LebensmittelHelper.getEinheit(lebensmittel: eintrag.lebensmittel!),
                                    name: eintrag.lebensmittel!.name!,
                                    kalorien: LebensmittelMengeHelper.getKalorien(eintrag: eintrag)
                                )
                            }
                            .onDelete(perform: delete)
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
            
            .navigationTitle("Ernährungsplan")
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: NewErnaehrungsplanView(lebensmittelManager: lebensmittelManager),
                    label: {
                        Text("Hinzufügen")
                        Image(systemName: "plus")
                    })
            )
        }
    }
    
    private func delete(offsets: IndexSet) {
        for index in offsets {
            lebensmittelManager.deleteLebensmittelMenge(lm: ernaehrungsplan[index])
        }
    }
}

struct ErnaehrungsplanView_Previews: PreviewProvider {
    static var previews: some View {
        ErnaehrungsplanView(lebensmittelManager: LebensmittelManager())
    }
}
