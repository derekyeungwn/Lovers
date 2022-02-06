//
//  LoversApp.swift
//  Lovers
//
//  Created by Derek Yeung on 23/11/2021.
//

import SwiftUI

@main
struct LoversApp: App {
    @StateObject private var loginData = LoginData()
    
    var body: some Scene {
        WindowGroup {
            ZStack() {
               if(loginData.isSignInCompleted && loginData.isAppCodeLoaded){
                    TabView {
                        HomeView()
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }
                        DatingListView()
                            .tabItem {
                                Label("Dating", systemImage: "heart.fill")
                            }
                        AccountView()
                            .tabItem {
                                Label("Account", systemImage: "person.fill")
                            }
                    }
                }else{
                    LoginView()
                }
            }
            .environmentObject(loginData)
        }
    }
}
