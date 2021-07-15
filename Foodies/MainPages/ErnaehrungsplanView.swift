import SwiftUI

struct ErnaehrungsplanView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
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
                                HStack {
                                    Text("\(Int(eintrag.menge))\(LebensmittelHelper.getEinheit(lebensmittel: eintrag.lebensmittel!))")
                                    Text(eintrag.lebensmittel?.name ?? "Fehler")
                                    Text(" \(LebensmittelMengeHelper.getKalorien(eintrag: eintrag))kcal")
                                        .fontWeight(.light)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .onDelete(perform: deleteEintrag)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .listStyle(GroupedListStyle())
                    .id(refreshID)
                    .onReceive(self.didSave) { _ in   //the listener
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
            offsets.map { ernaehrungsplan[$0] }.forEach(viewContext.delete)
            DataHelper.save(viewContext: viewContext)
        }
    }
}

struct ErnaehrungsplanView_Previews: PreviewProvider {
    static var previews: some View {
        ErnaehrungsplanView()
    }
}
