import SwiftUI

struct ProgressBar: View {
    var width: CGFloat = UIScreen.main.bounds.width * 0.75
    var progress: CGFloat = 50
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        let step = (width / 100) * (progress > 100 ? 100 : progress);
        let height: CGFloat = 40;
        
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .frame(width: width, height: height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.green.opacity(0.9))
            
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .frame(width: step > width ? width : (step < 0 ? 0 : step), height: height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor((progress > 100 ? .red : .blue))
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar()
    }
}
