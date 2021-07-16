import SwiftUI
import Combine
import CoreData

struct NewErnaehrungsplanMengeView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject
    var lebensmittelManager: LebensmittelManager
    
    @State private var menge: String = "";
    @State private var showingAlert = false;
    @State private var errorMsg: String = ""
    
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
                            message: Text(errorMsg)
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
        var eMsg:String?
        
        if(ernaehrungsPlan) {
            eMsg = lebensmittelManager.saveLebensmittelMenge(lebensmittel: lebensmittel, menge: menge)
            
        }
        else {
            eMsg = lebensmittelManager.saveLebensmittelMengeZeit(lebensmittel: lebensmittel, menge: menge)
        }
        
        if(eMsg != nil) {
            errorMsg = eMsg!
            showingAlert = true
            return
        }
        
        showingAlert = false
        
        
        self.mode.wrappedValue.dismiss();
    }
    
    struct NewErnaehrungsplanMengeView_Previews: PreviewProvider {
        static var previews: some View {
            NewErnaehrungsplanMengeView(lebensmittelManager: LebensmittelManager(), lebensmittel: Lebensmittel())
        }
    }
}
