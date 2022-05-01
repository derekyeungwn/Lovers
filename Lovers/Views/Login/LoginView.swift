//
//  LoginView.swift
//  Lovers
//
//  Created by Derek Yeung on 22/1/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginData : LoginData
    
    @State private var email = ""
    @State private var password = ""
    //@State private var email = "derekyeungwn@gmail.com"
    //@State private var password = "123"
    
    var body: some View {
        NavigationView {
            ZStack() {
                VStack(alignment: .center, spacing: 15){
                    Text("紀錄你重要的約會")
                        .font(.title)
                        .padding([.top], 50)
                        .padding([.bottom], 20)
                        //.shadow(radius: 6.0, x: 10, y: 10)
                    /*Image("")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle()
                        .stroke(Color.white, lineWidth: 3))
                        .shadow(radius: 9.0, x: 20, y: 10)
                        .padding(.bottom, 20)*/
                    TextField("電郵", text: self.$email)
                        //.padding(10)
                        //.background(Color.white)
                        //.cornerRadius(10.0)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("密碼", text: self.$password)
                        //.padding(10)
                        //.background(Color.white)
                        //.cornerRadius(10.0)
                    Button(action: {
                        Task{
                            await loginData.signIn(email: email, password: password)
                        }
                    }) {
                        Text("登入")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .background(Color.blue)
                            .cornerRadius(10.0)
                    }
                    .disabled(email == "" || password == "")
                    NavigationLink(destination: ForgotPasswordView()) {
                        HStack{
                            Spacer()
                            Text("忘記密碼?")
                                .font(.callout)
                                .foregroundColor(Color.white)
                        }
                    }
                    NavigationLink(destination: SignUpView()) {
                        Text("登記")
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10.0)
                    }
                    Spacer()
                }
                    .padding([.leading, .trailing], 30)
                    .padding([.top], -110)
                    /*.background(
                      LinearGradient(gradient: Gradient(colors: [.purple, .red]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))*/
                if loginData.isLoadingLoginView {
                    LoadingView()
                }
            }
            .alert(loginData.errMsgLoginView, isPresented: $loginData.showingAlertLoginView) {
                Button(action: {
                    loginData.isLoadingLoginView = false
                    loginData.showingAlertLoginView = false
                }) {
                    Text("OK")
                }
            }
            .task {
                if KeychainService.standard.read(service: "access_token", account: "lovers") != nil {
                    loginData.isSignInCompleted = true
                    await loginData.getAppCode()
                }
            }
            .navigationTitle("")
        }
        .accentColor(.white)
        .disabled(loginData.isLoadingLoginView)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginData())
            .preferredColorScheme(.dark)
    }
}
