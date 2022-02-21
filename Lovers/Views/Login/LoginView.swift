//
//  LoginView.swift
//  Lovers
//
//  Created by Derek Yeung on 22/1/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginData : LoginData
    
    @State private var email = "derekyeungwn@gmail.com"
    @State private var password = "123"
    
    var body: some View {
        ZStack() {
            VStack(alignment: .center, spacing: 15){
                Text("Welcome !")
                    .font(.title).foregroundColor(Color.white)
                    .padding([.top], 50)
                    .padding([.bottom], 50)
                    //.shadow(radius: 6.0, x: 10, y: 10)
                /*Image("")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle()
                    .stroke(Color.white, lineWidth: 3))
                    //.shadow(radius: 9.0, x: 20, y: 10)
                    .padding(.bottom, 40)*/
                TextField("Email", text: self.$email)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(25.0)
                    //.shadow(radius: 10.0, x: 5, y: 10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                SecureField("Password", text: self.$password)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(25.0)
                    .shadow(radius: 10.0, x: 5, y: 10)
                Button(action: {
                    Task{
                        await loginData.signIn(email: email, password: password)
                    }
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 40)
                        .background(Color.orange)
                        .cornerRadius(20.0)
                        //.shadow(radius: 10.0, x: 20, y: 10)
                }
                .disabled(email == "" || password == "")
                Spacer()
            }
                .padding([.leading, .trailing], 30)
                .background(
                  LinearGradient(gradient: Gradient(colors: [.purple, .red]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all))
            if loginData.isLoading {
                LoadingView()
            }
        }
        .alert("Wrong Email or Passowrd", isPresented: $loginData.showingAlert) {
            Button(action: {
                loginData.isLoading = false
                loginData.showingAlert = false
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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginData())
    }
}
