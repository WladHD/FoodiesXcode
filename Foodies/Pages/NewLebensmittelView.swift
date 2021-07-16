import SwiftUI
import CoreData
import Combine

struct NewLebensmittelView: View {
    @ObservedObject
    var lebensmittelManager: LebensmittelManager
    
    @State public var kcal: String = "";
    @State public var name: String = "";
    @State public var mengeneinheit: Int = 0;
    @State public var lebensmittelPreselect:Lebensmittel? = nil
    @State var eMsg:String = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var showingAlert = false;
    
    var body: some View {
        VStack() {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .multilineTextAlignment(.center)
                    
                    Picker(selection: $mengeneinheit, label: Text("Mengeneinheit")) {
                        ForEach(0..<LebensmittelHelper.kalProEinheitFormat.count) {
                            Text(LebensmittelHelper.kalProEinheitFormat[$0]).tag($0)
                        }
                    }
                    
                    TextField("\(LebensmittelHelper.kalProEinheitFormat[mengeneinheit])", text: $kcal)
                        .keyboardType(.numberPad)
                        .onReceive(Just(kcal)) { index in
                            let filtered = index.filter { "0123456789".contains($0) }
                            if filtered != index {
                                self.kcal = filtered
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
                            message: Text(eMsg)
                        )
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
        }.navigationTitle("Neues Lebensmittel")
        
    }
    
    private func onSavePress() {
        let err = lebensmittelManager.saveLebensmittel(name: name, kcal: kcal, mengeneinheit: Int64(mengeneinheit))
        
        if(err != nil) {
            eMsg = err!
            showingAlert = true;
            return;
        }
        
        showingAlert = false
        
        self.mode.wrappedValue.dismiss();
    }
}

struct NewLebensmittelView_Previews: PreviewProvider {
    static var previews: some View {
        NewLebensmittelView(lebensmittelManager: LebensmittelManager())
    }
}
