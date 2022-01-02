//
//  LoadingView.swift
//  Learning
//
//  Created by Derek Yeung on 20/11/2021.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.black).opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            ProgressView().scaleEffect(2.0, anchor: .center)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
