import Foundation
import SwiftUI
import CryptoKit

@MainActor
class LoginData: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var isSignInCompleted: Bool = false
    @Published var isAppCodeLoaded: Bool = false
    @Published var showingAlert: Bool = false
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
                    isSignInCompleted = true
                    KeychainService.standard.save(data: access_token, service: "access_token", account: "lovers")
                }
            }
            
            await getAppCode()
            
        } catch {
            isLoading = false
            print("\(error.localizedDescription)")
        }
    }
    
    func signOut(){
        isSignInCompleted = false
        isAppCodeLoaded = false
        KeychainService.standard.delete(service: "access_token", account: "lovers")
    }
    
    func getAppCode() async {
        isLoading = true
        
        let url = URL(string: "\(API_URL)/appCode/")!
        var request = URLRequest(url: url)
        request.setValue( "Bearer \(KeychainService.standard.read(service: "access_token", account: "lovers")!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                isLoading = false
                return
            }
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let a = try decoder.decode(AppCode.Result.self, from: data)
            
            appCode = a.data[0]
            
            isAppCodeLoaded = true
            isLoading = false
        }
        catch {
            isLoading = false
            print("\(error.localizedDescription)")
        }
    }
}
