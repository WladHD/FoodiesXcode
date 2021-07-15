//
//  BackgroundView.swift
//  Foodies
//
//  Created by WJ on 14.07.21.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("background")
            .resizable()
            .ignoresSafeArea()
            .opacity(0.3)
            .aspectRatio(contentMode: .fill)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
