//
//  NewErnaehrungsplanView.swift
//  Foodies
//
//  Created by WJ on 14.07.21.
//

import SwiftUI
import CoreData

struct NewErnaehrungsplanView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var lebensmittel: FetchedResults<Lebensmittel>
    
    @State var checks = [Check]()
    
    struct Check {
        var lebensmittel:Lebensmittel
        var checked:Bool
    }
    
    func appendCheck(lebensmittelCheck:Lebensmittel) -> Lebensmittel {
        self.checks.append(Check(lebensmittel: lebensmittelCheck, checked: false))
        
        return lebensmittelCheck;
    }
    
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
                                    Text(lm.name!)
                                    Text(" \(lm.kcal)kcal " + LebensmittelHelper.getKalProEinheitFormat(lebensmittel: lm))
                                        .fontWeight(.light)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    
                                }
                                /*
                                .contextMenu {
                                    Button(action: {
                                        self.showEditView = true
                                    }, label: {
                                        HStack {
                                            Text("Bearbeiten")
                                            Image(systemName: "pencil")
                                        }
                                    })
                                }
                                
                                NavigationLink (
                                    destination: NewLebensmittelView(kcal: String(lm.kcal), name: String(lm.name!), mengeneinheit: Int(lm.mengeneinheit) - 1, lebensmittelPreselect: lm),
                                    isActive: $checks[1].checked) {
                                }
                                .frame(width: 0, height: 0)
                                .hidden()*/
                            }
                            
                        }
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .listStyle(GroupedListStyle())
            }
            .padding(.top)
            .navigationTitle("Lebensmittel")
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: NewLebensmittelView(),
                    label: {
                        Text("Neu")
                        Image(systemName: "plus")
                    })
            )
        }
    }
}

struct NewErnaehrungsplanView_Previews: PreviewProvider {
    static var previews: some View {
        NewErnaehrungsplanView()
    }
}
