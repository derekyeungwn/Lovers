//
//  SignUpView.swift
//  Lovers
//
//  Created by Derek Yeung on 9/3/2022.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var loginData : LoginData
    
    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    
    var body: some View {
        ZStack() {
            VStack(spacing:20){
                TextField("電郵*", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                SecureField("密碼* (長度最小8個字元)", text: $password1)
                if password1.count < 8 && password1 != ""{
                    HStack{
                        Text("長度最小8個字元")
                            .foregroundColor(Color.red)
                            .font(.footnote)
                            .padding(.top, -10)
                        Spacer()
                    }
                }
                SecureField("再次輸入密碼* (長度最小8個字元)", text: $password2)
                if password1 != password2 && password2 != ""{
                    HStack{
                        Text("密碼不一致")
                            .foregroundColor(Color.red)
                            .font(.footnote)
                            .padding(.top, -10)
                        Spacer()
                    }
                }
                Button(action: {
                    Task{
                        await loginData.signUp(email: email, password: password2)
                    }
                }){
                    Text("完成")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 5)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10.0)
                }
                .disabled(email == "" || password1 == "" || password2 == "" || password1 != password2 || password1.count < 8)
                Spacer()
            }
            if loginData.isLoadingSignUpView {
                LoadingView()
            }
        }
        .alert(loginData.errMsgSignUpView, isPresented: $loginData.showingAlertSignUpView) {
            Button(action: {
                loginData.isLoadingSignUpView = false
                loginData.showingAlertSignUpView = false
            }) {
                Text("OK")
            }
        }
        .padding([.leading, .trailing], 10)
        .padding(.top, 20)
        .navigationBarTitle("註冊")
        .navigationBarTitleDisplayMode(.inline)
        .disabled(loginData.isLoadingSignUpView)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
                .environmentObject(LoginData())
                .preferredColorScheme(.dark)
        }
    }
}
