//
//  DatingData.swift
//  Learning
//
//  Created by Derek Yeung on 14/11/2021.
//

import Foundation
import SwiftUI

@MainActor
class DatingData: ObservableObject {
    
    @Published var datings: [Dating] = []
    @Published var isLoading: Bool = false
    
    func getData(token: String) async {
        isLoading = true
        
        let url = URL(string: "\(API_URL)/datings/")!
        var request = URLRequest(url: url)
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
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
            
            let a = try decoder.decode(Dating.Result.self, from: data)
            
            datings = a.data
            datings.sort {$0.date > $1.date}
        }
        catch {
            print("getData Error!!!")
        }
        
        isLoading = false
    }
}
