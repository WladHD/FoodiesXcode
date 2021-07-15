//
//  NewErnährungsplanMengeView.swift
//  Foodies
//
//  Created by WJ on 14.07.21.
//

import SwiftUI
import Combine
import CoreData

struct NewErnaehrungsplanMengeView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var menge: String = "";
    @State private var showingAlert = false;
    
    var lebensmittel: Lebensmittel
    var ernaehrungsPlan:Bool = true
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Bitte gebe die Menge für \(lebensmittel.name!) an")
            
            TextField("Menge in \(LebensmittelHelper.getEinheit(lebensmittel: lebensmittel))", text: $menge)
                .keyboardType(.numberPad)
                .onReceive(Just(menge)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.menge = filtered
                    }
                }
                .multilineTextAlignment(.center)
            
            Button("Speichern") {
                onSavePress()
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Fehler"),
                    message: Text("Menge darf nicht leer sein")
                )
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding(.top)
        .navigationTitle("Mengenangabe")
    }
    
    private func onSavePress() {
        if(menge.count == 0) {
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
        let newLebensmittelMengeZeit = LebensmittelMengeZeit(context: viewContext)
        newLebensmittelMengeZeit.lebensmittel = lebensmittel;
        newLebensmittelMengeZeit.menge = Int64(menge)!;
        newLebensmittelMengeZeit.zeitpunkt = Date()
        
        DataHelper.save(viewContext: viewContext)
    }
    
    private func saveLebensmittelMenge() {
        
        let newLebensmittelMenge = lebensmittel.ernaehrungsplan == nil ? LebensmittelMenge(context: viewContext) : lebensmittel.ernaehrungsplan!;
        
        if(lebensmittel.ernaehrungsplan == nil) {
            newLebensmittelMenge.lebensmittel = lebensmittel;
            newLebensmittelMenge.menge = Int64(menge)!
        } else {
            newLebensmittelMenge.menge += Int64(menge)!
        }
        
        
        DataHelper.save(viewContext: viewContext)
    }
    
    struct NewErnaehrungsplanMengeView_Previews: PreviewProvider {
        static var previews: some View {
            NewErnaehrungsplanMengeView(lebensmittel: Lebensmittel())
        }
    }
}
