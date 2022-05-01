import Foundation
import SwiftUI
import CryptoKit

@MainActor
class LoginData: ObservableObject {
    
    @Published var isLoadingLoginView: Bool = false
    @Published var showingAlertLoginView: Bool = false
    @Published var errMsgLoginView: String = ""
    
    @Published var isLoadingSignUpView: Bool = false
    @Published var showingAlertSignUpView: Bool = false
    @Published var errMsgSignUpView: String = ""
    
    @Published var isLoadingForgotPasswordView: Bool = false
    @Published var showingAlertForgotPasswordView: Bool = false
    @Published var errMsgForgotPasswordView: String = ""
    
    @Published var isSignInCompleted: Bool = false
    @Published var isAppCodeLoaded: Bool = false
    @Published var isResetPasswordCompleted: Bool = false
    
    var appCode: AppCode = AppCode()
    
    struct AppCode: Codable{
        var cuisine: [String] = []
        var area: [String] = []
        var user_name: String = ""
        var user_id: String = ""
    }
    
    func resetPassword(email: String) async {
        isLoadingForgotPasswordView = true
        
        do {
            let url = URL(string: "\(Config.API_URL)/resetPassword/")!
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            request.httpMethod = "POST"
            
            let jsonDictionary: [String: String] = [
                "email": email
            ]
        
            let reqData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            let (resData, _) = try await URLSession.shared.upload(for: request, from: reqData)
            
            struct Response: Codable{
            }
            struct Result: Codable
            {
                let success: Bool
                let error_message: String?
                let response: Response?
            }
            let result = try JSONDecoder().decode(Result.self, from: resData)
            
            if !result.success {
                isLoadingForgotPasswordView = false
                showingAlertForgotPasswordView = true
                errMsgForgotPasswordView = result.error_message!
                return
            }
            
            isLoadingForgotPasswordView = false
            isResetPasswordCompleted = true
            
        } catch {
            isLoadingForgotPasswordView = false
            showingAlertForgotPasswordView = true
            errMsgForgotPasswordView = "Internal Server Error"
            print("\(error.localizedDescription)")
        }
    }

    func signUp(email: String, password: String) async {
        isLoadingSignUpView = true
        
        do {
            let url = URL(string: "\(Config.API_URL)/users/")!
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            request.httpMethod = "POST"
            
            let jsonDictionary: [String: String] = [
                "email": email,
                "password": password
            ]
        
            let reqData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            let (resData, _) = try await URLSession.shared.upload(for: request, from: reqData)
            
            struct Response: Codable{
                let access_token: String?
                let user_id: String?
            }
            struct Result: Codable
            {
                let success: Bool
                let error_message: String?
                let response: Response?
            }
            let result = try JSONDecoder().decode(Result.self, from: resData)
            
            if !result.success {
                isLoadingSignUpView = false
                showingAlertSignUpView = true
                errMsgSignUpView = result.error_message!
                return
            }
            
            KeychainService.standard.save(data: result.response!.access_token!, service: "access_token", account: "lovers")
            isSignInCompleted = true
            
            await getAppCode()
            
        } catch {
            isLoadingSignUpView = false
            showingAlertSignUpView = true
            errMsgLoginView = "Internal Server Error"
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoadingLoginView = true
        
        do {
            let url = URL(string: "\(Config.API_URL)/login/")!
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            request.httpMethod = "PUT"
            
            let jsonDictionary: [String: String] = [
                "email": email,
                "password": password
            ]
            
            let reqData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            let (resData, _) = try await URLSession.shared.upload(for: request, from: reqData)
            
            struct Response: Codable{
                let access_token: String?
                let user_name: String?
                let user_id: String?
            }
            struct Result: Codable
            {
                let success: Bool
                let error_message: String?
                let response: Response?
            }
            let result = try JSONDecoder().decode(Result.self, from: resData)
            
            if !result.success {
                isLoadingLoginView = false
                showingAlertLoginView = true
                errMsgLoginView = result.error_message!
                return
            }
            
            KeychainService.standard.save(data: result.response!.access_token!, service: "access_token", account: "lovers")
            isSignInCompleted = true
            
            await getAppCode()
            
        } catch {
            isLoadingLoginView = false
            showingAlertLoginView = true
            errMsgLoginView = "Internal Server Error"
            print("\(error.localizedDescription)")
        }
    }
    
    func signOut(){
        isSignInCompleted = false
        isAppCodeLoaded = false
        KeychainService.standard.delete(service: "access_token", account: "lovers")
    }
    
    func getAppCode() async {
        do {
            let url = URL(string: "\(Config.API_URL)/appCode/")!
            var request = URLRequest(url: url)
            request.setValue( "Bearer \(KeychainService.standard.read(service: "access_token", account: "lovers")!)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            let (resData, _) = try await URLSession.shared.data(for: request)
            
            struct Result: Codable
            {
                let success: Bool
                let error_message: String?
                let response: AppCode?
            }
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let result = try decoder.decode(Result.self, from: resData)
            
            if !result.success {
                isLoadingLoginView = false
                showingAlertLoginView = true
                errMsgLoginView = result.error_message!
                return
            }
        
            appCode = result.response!
            
            isAppCodeLoaded = true
            isLoadingLoginView = false
            isLoadingSignUpView = false
        }
        catch {
            isLoadingLoginView = false
            showingAlertLoginView = true
            print("\(error.localizedDescription)")
        }
    }
}
