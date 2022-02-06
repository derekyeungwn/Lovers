import Foundation
import SwiftUI
import CryptoKit

@MainActor
class LoginData: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var isSignInCompleted: Bool = false
    @Published var isAppCodeLoaded: Bool = false
    @Published var showingAlert: Bool = false
    var login: Login = Login()
    var appCode: AppCode = AppCode()
    
    func signIn(email: String, password: String) async {
        isLoading = true
        
        do {
            let url = URL(string: "\(API_URL)/login/")!
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            request.httpMethod = "PUT"
            
            let jsonDictionary: [String: String] = [
                "email": email,
                "password": SHA256.hash(data: Data(password.utf8)).compactMap { String(format: "%02x", $0) }.joined()
            ]
        
            let reqData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            let (resData, response) = try await URLSession.shared.upload(for: request, from: reqData)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                isLoading = false
                showingAlert = true
                return
            }
            
            if let json = try JSONSerialization.jsonObject(with: resData, options: []) as? [String: String] {
                if let access_token = json["access_token"] {
                        login.token = access_token
                    login.token = json["access_token"]!
                    login.user_name = json["user_name"]!
                    login.user_id = json["user_id"]!
                    isSignInCompleted = true
                }
            }
            
            await getAppCode()
            
        } catch {
            print("\(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func signOut(){
        login.token = ""
        isSignInCompleted = false
        isAppCodeLoaded = false
    }
    
    func getAppCode() async {
        let url = URL(string: "\(API_URL)/appCode/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let a = try decoder.decode(AppCode.Result.self, from: data)
            
            appCode = a.data[0]
            
            isAppCodeLoaded = true
        }
        catch {
            print("\(error.localizedDescription)")
        }
    }
}
