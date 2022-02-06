//
//  App_CodeData.swift
//  Lovers
//
//  Created by Derek Yeung on 15/1/2022.
//

import Foundation

@MainActor
class AppCodeData: ObservableObject {
    var appCode: AppCode = AppCode()
    
    func getData() async {
        
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
        }
        catch {
            print("getData Error!!!")
        }
    }
}
