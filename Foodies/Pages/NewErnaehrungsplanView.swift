import SwiftUI
import CoreData

struct NewErnaehrungsplanView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var lebensmittel: FetchedResults<Lebensmittel>
    
    var ernaehrungsPlan:Bool = true
    
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()
            
            VStack(spacing: 50) {
                List {
                    Section(header: Text("Lebensmittel auswählen")) {
                        
                        ForEach(lebensmittel) { lm in
                            
                            VStack {
                                
                                NavigationLink(destination: NewErnaehrungsplanMengeView(lebensmittel: lm, ernaehrungsPlan: ernaehrungsPlan)) {
                                    
                                    LebensmittelRowView(
                                        menge: -1,
                                        einheit: LebensmittelHelper.getKalProEinheitFormat(lebensmittel: lm),
                                        name: lm.name!,
                                        kalorien: lm.kcal
                                    )
                                    
                                }
                            }
                            
                        }
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .listStyle(GroupedListStyle())
            }
            .padding(.top)
            
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: NewLebensmittelView(),
                    label: {
                        Text("Neu")
                        Image(systemName: "plus")
                    }
                
                )
                
            ).navigationTitle("Lebensmittel")
        }
    }
}

struct NewErnaehrungsplanView_Previews: PreviewProvider {
    static var previews: some View {
        NewErnaehrungsplanView()
    }
}
