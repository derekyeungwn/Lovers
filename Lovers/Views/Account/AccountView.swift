//
//  AccountView.swift
//  Lovers
//
//  Created by Derek Yeung on 12/1/2022.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var loginData : LoginData
    
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
                
                Button(action: {
                    loginData.signOut()
                }) {
                    Text("Sign Out")
                }
            }
            .navigationBarTitle(Text("\(loginData.appCode.user_name)"))
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(LoginData())
    }
}
