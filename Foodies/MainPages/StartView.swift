import SwiftUI

struct StartView: View {
    var body: some View {
        TabView {
            TagesberichtView()
                .modifier(StartViewTab(img: "doc.text", txt: "Tagesbericht"))
            
            ErnaehrungsplanView()
                .modifier(StartViewTab(img: "heart.text.square", txt: "Ernährungsplan"))
            
            VerlaufView()
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
