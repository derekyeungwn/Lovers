//
//  SettingView.swift
//  Lovers
//
//  Created by Derek Yeung on 12/1/2022.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("ABOUT")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("\(APP_VER)")
                    }
                }
            }
            .navigationBarTitle(Text("Settings"))
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
