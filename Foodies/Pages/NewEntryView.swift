import SwiftUI

struct NewEntryView: View {
    var body: some View {
        VStack {
            NavigationLink(
                destination: NewErnaehrungsplanView(ernaehrungsPlan: false)) {
                ZStack {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 150, height: 150, alignment: .center)
                        .cornerRadius(20)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "bag.badge.plus")
                            .foregroundColor(.white)
                            .font(.title2)
                        Text("Essen")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.title2)
                    }
                }
            }
            
            NavigationLink(
                destination: NewBMIView()) {
                ZStack {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 150, height: 150, alignment: .center)
                        .cornerRadius(20)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(.white)
                            .font(.title2)
                        Text("Körperdaten")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.title2)
                        
                    }
                }
            }
        }
        .navigationTitle("Neue Aufzeichnung")
    }
}

struct NewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NewEntryView()
    }
}
