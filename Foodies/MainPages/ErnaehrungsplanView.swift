import SwiftUI

struct ErnaehrungsplanView: View {
    @FetchRequest(sortDescriptors: [])
    private var ernaehrungsplan: FetchedResults<LebensmittelMenge>
    
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
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
                            .onDelete(perform: deleteEintrag)
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
                    destination: NewErnaehrungsplanView(),
                    label: {
                        Text("Hinzufügen")
                        Image(systemName: "plus")
                    })
            )
        }
    }
    
    private func deleteEintrag(offsets: IndexSet) {
        withAnimation {
            offsets.map { ernaehrungsplan[$0] }.forEach(DatabaseHelper.getInstance().getViewContext().delete)
            DatabaseHelper.getInstance().save()
        }
    }
}

struct ErnaehrungsplanView_Previews: PreviewProvider {
    static var previews: some View {
        ErnaehrungsplanView()
    }
}
