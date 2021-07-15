import SwiftUI
import Combine
import CoreData

struct NewErnaehrungsplanMengeView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var menge: String = "";
    @State private var showingAlert = false;
    
    var lebensmittel: Lebensmittel
    var ernaehrungsPlan:Bool = true
    
    var body: some View {
        VStack() {
            Form {
                Section {
                    Text("Bitte gebe die Menge für \(lebensmittel.name!) an")
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    
                    TextField("Menge in \(LebensmittelHelper.getEinheit(lebensmittel: lebensmittel))", text: $menge)
                        .keyboardType(.numberPad)
                        .onReceive(Just(menge)) { index in
                            let filtered = index.filter { "0123456789".contains($0) }
                            if filtered != index {
                                self.menge = filtered
                            }
                        }
                        .multilineTextAlignment(.center)
                    
                }
                Section {
                    Button("Speichern") {
                        onSavePress()
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Fehler"),
                            message: Text("Menge darf nicht leer und muss eine Zahl sein")
                        )
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
                
            }
            
        }.navigationTitle("Mengenangabe")
    }
    
    private func onSavePress() {
        if(menge.count == 0 || Int64(menge) == nil || Int64(menge)! <= 0) {
            self.showingAlert = true;
            return;
        }
        
        if(ernaehrungsPlan) {
            saveLebensmittelMenge()
        } else {
            saveLebensmittelMengeZeit()
        }
        
        
        self.mode.wrappedValue.dismiss();
    }
    
    private func saveLebensmittelMengeZeit() {
        let newLebensmittelMengeZeit = LebensmittelMengeZeit(context: DatabaseHelper.getInstance().getViewContext())
        newLebensmittelMengeZeit.lebensmittel = lebensmittel;
        newLebensmittelMengeZeit.menge = Int64(menge)!;
        newLebensmittelMengeZeit.zeitpunkt = Date()
        
        DatabaseHelper.getInstance().save()
    }
    
    private func saveLebensmittelMenge() {
        
        let newLebensmittelMenge = lebensmittel.ernaehrungsplan == nil ? LebensmittelMenge(context: DatabaseHelper.getInstance().getViewContext()) : lebensmittel.ernaehrungsplan!;
        
        if(lebensmittel.ernaehrungsplan == nil) {
            newLebensmittelMenge.lebensmittel = lebensmittel;
            newLebensmittelMenge.menge = Int64(menge)!
        } else {
            newLebensmittelMenge.menge += Int64(menge)!
        }
        
        
        DatabaseHelper.getInstance().save()
    }
    
    struct NewErnaehrungsplanMengeView_Previews: PreviewProvider {
        static var previews: some View {
            NewErnaehrungsplanMengeView(lebensmittel: Lebensmittel())
        }
    }
}
