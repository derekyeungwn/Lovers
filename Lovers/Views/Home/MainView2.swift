//
//  MainView2.swift
//  Lovers
//
//  Created by Derek Yeung on 6/2/2022.
//

import SwiftUI

struct MainView2: View {
    var body: some View {
        TabView(selection: .constant(0),
                content: {
                    HomeView()
                        .tag(0)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .ignoresSafeArea()
            
            })
    }
}

struct MainView2_Previews: PreviewProvider {
    static var previews: some View {
        MainView2()
    }
}
