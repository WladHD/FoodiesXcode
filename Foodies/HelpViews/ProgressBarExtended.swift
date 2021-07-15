import SwiftUI

struct ProgressBarExtended: View {
    var curKalorien:CGFloat = -1
    var maxKalorien:CGFloat = 2500
    
    var body: some View {
        ZStack {
            ProgressBar(progress: (curKalorien / (maxKalorien <= 0 ? CGFloat(100) : maxKalorien) * 100))
            Text((curKalorien < 0 ? "" : "\(Int(curKalorien))") + (maxKalorien <= 0 || curKalorien < 0 ? "" : " / ") +  (maxKalorien <= 0 ? (curKalorien < 0 ? "0" : "") : "\(Int(maxKalorien))") + " kcal")
                .foregroundColor(.white)
                .bold()
                .shadow(radius: 1)
        }
    }
}

struct ProgressBarExtended_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarExtended()
    }
}
