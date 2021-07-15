//
//  ContentView.swift
//  Foodies
//
//  Created by WJ on 14.07.21.
//

import SwiftUI

struct StartView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            TagesberichtView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
