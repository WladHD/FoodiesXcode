import SwiftUI

struct LebensmittelRowView: View {
    @State var menge:Int64 = 0
    @State var einheit:String = ""
    @State var name:String = ""
    @State var kalorien:Int64 = 0
    
    var body: some View {
        HStack {
            if(menge >= 0) {
                Text("\(Int(menge))\(einheit)")
            }
            
            Text(name)
            Text(" \(Int(kalorien)) kcal" + (menge < 0 ? " " + einheit : ""))
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct LebensmittelRowView_Previews: PreviewProvider {
    static var previews: some View {
        LebensmittelRowView()
    }
}
