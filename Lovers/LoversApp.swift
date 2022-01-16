//
//  LoversApp.swift
//  Lovers
//
//  Created by Derek Yeung on 23/11/2021.
//

import SwiftUI

@main
struct LoversApp: App {
    @StateObject private var datingData = DatingData()
    @StateObject private var appCodeData = AppCodeData()
    
    var body: some Scene {
        WindowGroup {
            ZStack() {
                TabView {
                    DatingListView()
                        .task {
                            await datingData.load()
                        }
                        .tabItem {
                            Label("Dating", systemImage: "heart.fill")
                        }
                    //if datingData.isLoading {
                    //    LoadingView()
                    //}
                    SettingView()
                        .tabItem {
                            Label("Setting", systemImage: "gearshape.fill")
                        }
                }
            }
            .environmentObject(datingData)
            .environmentObject(appCodeData)
            .task {
                await appCodeData.load()
            }
        }
    }
}
