import SwiftUI

struct StartView: View {
    @StateObject var lebensmittelMengeManager = LebensmittelManager()
    
    var body: some View {
        TabView {
            TagesberichtView(lebensmittelManager: lebensmittelMengeManager)
                .modifier(StartViewTab(img: "doc.text", txt: "Tagesbericht"))
            
            ErnaehrungsplanView(lebensmittelManager: lebensmittelMengeManager)
                .modifier(StartViewTab(img: "heart.text.square", txt: "Ernährungsplan"))
            
            VerlaufView(lebensmittelManager: lebensmittelMengeManager)
                .modifier(StartViewTab(img: "clock.arrow.circlepath", txt: "Verlauf"))
        }
    }
}

struct StartViewTab: ViewModifier {
    var img:String
    var txt:String
    
    func body(content: Content) -> some View {
        return content
            .tabItem {
                Image(systemName: img)
                Text(txt)
            }
        ;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
