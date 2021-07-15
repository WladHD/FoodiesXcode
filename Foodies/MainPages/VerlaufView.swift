//
//  VerlaufView.swift
//  Foodies
//
//  Created by WJ on 14.07.21.
//

import SwiftUI
import CoreData

struct VerlaufView: View {
    @State private var maxKalorien: CGFloat = 2500;
    @State private var curKalorien: CGFloat = 1500;
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    @State private var scopeDatum = Date()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "zeitpunkt", ascending: false)])
    private var gesamtverlaufMengeZeit: FetchedResults<LebensmittelMengeZeit>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "zeitpunkt", ascending: false)])
    private var gesamtverlaufBMIVerlauf: FetchedResults<BMIVerlauf>
    
    
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    @State private var refreshID = UUID()
    
    
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                BackgroundView()
                
                VStack(spacing: 50) {
                    DatePicker(
                        "Tag auswählen",
                        selection: $scopeDatum,
                        in: ...Date(),
                        displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .frame(width: UIScreen.main.bounds.width * 0.75, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                    
                    
                    
                    //Text("Date is \(scopeDatum, formatter: dateFormatter)")
                    
                    ProgressBarExtended(curKalorien: -1, maxKalorien: LebensmittelMengeZeitHelper.getComsumedCalories(day: scopeDatum, gesamtverlauf: gesamtverlaufMengeZeit))
                    
                    let bmi:BMIVerlauf? = BMIHelper.getClosestDateBelow(day: scopeDatum, gesamtverlauf: gesamtverlaufBMIVerlauf);
                    
                    if(bmi != nil) {
                        VStack(spacing: 10) {
                            Text("BMI vom \((bmi?.zeitpunkt!)!, formatter: dateFormatter)")
                            
                            let gewicht:Double = Double(bmi?.gewicht ?? 1);
                            let groesse:Double = Double(bmi?.groesse ?? 1) / 100;
                            
                            Text("\(gewicht, specifier: "%.1f")kg - \(groesse, specifier: "%.2f")m - BMI \(gewicht / (groesse * groesse), specifier: "%.1f")")
                        }
                    }
                    
                    
                    List {
                        Section(header: Text("Was habe ich gegessen?")) {
                            ForEach(gesamtverlaufMengeZeit) { verlauf in
                                if(Calendar.current.compare(verlauf.zeitpunkt!, to: scopeDatum, toGranularity: .day) == ComparisonResult.orderedSame) {
                                    HStack {
                                        Text("\(Int(verlauf.menge))\(LebensmittelHelper.getEinheit(lebensmittel: verlauf.lebensmittel!))")
                                        Text(verlauf.lebensmittel?.name ?? "Fehler")
                                        Text(" \(LebensmittelMengeZeitHelper.getKalorien(eintrag: verlauf))kcal")
                                            .fontWeight(.light)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                            }
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
            
            .navigationTitle("Verlauf")
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: NewEntryView(),
                    label: {
                        Text("Hinzufügen")
                        Image(systemName: "plus")
                    }
                )
            )
            
        }
    }
    
    struct VerlaufView_Previews: PreviewProvider {
        static var previews: some View {
            VerlaufView()
        }
    }
}
