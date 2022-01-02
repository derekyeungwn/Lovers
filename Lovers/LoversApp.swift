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
    
    var body: some Scene {
        WindowGroup {
            ZStack() {
                DatingListView()
                    .task {
                        await datingData.load()
                    }
                if datingData.isLoading {
                    LoadingView()
                }
            }
            .environmentObject(datingData)
        }
    }
}
