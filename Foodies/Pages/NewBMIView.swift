//
//  NewLebensmittelView.swift
//  Foodies
//
//  Created by WJ on 14.07.21.
//

import SwiftUI
import CoreData
import Combine

struct NewBMIView: View {
    
    @State public var groesse: String = "";
    @State public var gewicht: String = "";
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingAlert = false;
    
    var body: some View {
        VStack() {
            
            Form {
                Section {
                    TextField("Größe in cm", text: $groesse)
                        .keyboardType(.numberPad)
                        .onReceive(Just(groesse)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.groesse = filtered
                            }
                        }
                        .multilineTextAlignment(.center)
                    
                    TextField("Gewicht in kg", text: $gewicht)
                        .keyboardType(.numberPad)
                        .onReceive(Just(gewicht)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.gewicht = filtered
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
                            message: Text("Größe und Gewicht dürfen nicht leer sein")
                        )
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
        }.navigationTitle("Neuer BMI Eintrag")
        
    }
    
    private func onSavePress() {
        if(groesse.count == 0 || gewicht.count == 0) {
            showingAlert = true;
            return;
        } else {
            showingAlert = false;
        }
        
        let bmiEintrag = BMIVerlauf(context: viewContext);
        bmiEintrag.gewicht = Double(gewicht)!
        bmiEintrag.groesse = Int64(groesse)!
        bmiEintrag.zeitpunkt = Date()
        
        DataHelper.save(viewContext: viewContext)
        self.mode.wrappedValue.dismiss();
    }
}

struct NewBMIView_Previews: PreviewProvider {
    static var previews: some View {
        NewBMIView()
    }
}
