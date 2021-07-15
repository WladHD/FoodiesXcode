import SwiftUI

struct StartView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            TagesberichtView()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("Tagesbericht")
                }
            
            ErnaehrungsplanView()
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("Ernährungsplan")
                }
            
            VerlaufView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Verlauf")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
