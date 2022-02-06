//
//  HomeView.swift
//  Lovers
//
//  Created by Derek Yeung on 29/1/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loginData : LoginData
    @State private var isPresented = false
    
    var body: some View {
        Text("hello")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LoginData())
    }
}
