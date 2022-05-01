//
//  ForgotPasswordView.swift
//  Lovers
//
//  Created by Derek Yeung on 9/3/2022.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var loginData : LoginData
    
    @State private var email = ""
    
    var body: some View {
        ZStack() {
            VStack(spacing:20){
                if(!loginData.isResetPasswordCompleted){
                    TextField("請輸入電郵*", text: $email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Button(action: {
                        Task{
                            await loginData.resetPassword(email: email)
                        }
                    }){
                        Text("確定")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 5)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10.0)
                    }
                    .disabled(email == "")
                    Spacer()
                }else{
                    Text("重置密碼連結巳被傳送，請檢查完成重設程序。")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Text("返回登入頁面")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 5)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10.0)
                    }
                    Spacer()
                }
            }
            if loginData.isLoadingForgotPasswordView {
                LoadingView()
            }
        }
        .alert(loginData.errMsgForgotPasswordView, isPresented: $loginData.showingAlertForgotPasswordView) {
            Button(action: {
                loginData.isLoadingForgotPasswordView = false
                loginData.showingAlertForgotPasswordView = false
            }) {
                Text("OK")
            }
        }
        .padding([.leading, .trailing], 10)
        .padding(.top, 20)
        .navigationBarTitle("忘記密碼")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loginData.isResetPasswordCompleted = false
        }
        .disabled(loginData.isLoadingForgotPasswordView)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ForgotPasswordView()
                .preferredColorScheme(.dark)
        }
    }
}
