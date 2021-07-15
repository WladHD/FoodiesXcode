import SwiftUI
import CoreData
import Combine

struct NewLebensmittelView: View {
    
    @State public var kcal: String = "";
    @State public var name: String = "";
    @State public var mengeneinheit: Int = 0;
    @State public var lebensmittelPreselect:Lebensmittel? = nil
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var showingAlert = false;
    
    @FetchRequest(sortDescriptors: [])
    private var lebensmittel: FetchedResults<Lebensmittel>
    
    
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
                            message: Text("Menge und Name dürfen nicht leer sein")
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
    
    private func parseLebensmittel(pName: String) -> Lebensmittel? {
        for lm in lebensmittel {
            if(pName.compare(lm.name!, options: .caseInsensitive) == ComparisonResult.orderedSame) {
                return lm;
            }
        }
        
        return nil;
    }
    
    private func onSavePress() {
        if(name.count == 0 || kcal.count == 0 || Int64(kcal) == nil || Int64(kcal)! <= 0) {
            showingAlert = true;
            return;
        } else {
            showingAlert = false;
        }
        
        lebensmittelPreselect = parseLebensmittel(pName: name)
        
        if(lebensmittelPreselect == nil) {
            lebensmittelPreselect = Lebensmittel(context: DatabaseHelper.getInstance().getViewContext());
        }
        
        lebensmittelPreselect?.name = name;
        lebensmittelPreselect?.kcal = Int64(kcal)!;
        lebensmittelPreselect?.mengeneinheit = Int64(mengeneinheit + 1);
        
        DatabaseHelper.getInstance().save()
        self.mode.wrappedValue.dismiss();
    }
}

struct NewLebensmittelView_Previews: PreviewProvider {
    static var previews: some View {
        NewLebensmittelView()
    }
}
