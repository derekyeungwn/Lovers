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
    
    func getData() async {
        isLoading = true
        
        let url = URL(string: "\(API_URL)/datings/")!
        var request = URLRequest(url: url)
        guard let token = KeychainService.standard.read(service: "access_token", account: "lovers") else {
            isLoading = false
            return
        }
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
            isLoading = false
            print("getData Error!!!")
        }
        
        isLoading = false
    }
    
    func sortDating() {
        datings.sort {$0.date > $1.date}
    }
    
    func deleteDating(id: Int) async {
        if let index = datings.firstIndex(where: {$0.id == id}) {
            datings.remove(at: index)
        }
        do {
            let url = URL(string: "\(API_URL)/datings/\(id)")!
            var request = URLRequest(url: url)
            request.setValue( "Bearer \(KeychainService.standard.read(service: "access_token", account: "lovers")!)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "DELETE"
            
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            print("error")
        }
    }
    
    func updateDating(updatedDatingData: Dating.DatingData) async {
        do {
            let index = datings.firstIndex(where: {$0.id == updatedDatingData.id})!
            datings[index].date = updatedDatingData.date
            datings[index].breakfast = updatedDatingData.breakfast
            datings[index].lunch = updatedDatingData.lunch
            datings[index].dinner = updatedDatingData.dinner
            datings[index].activities = updatedDatingData.activities
            
            sortDating()
            
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            let encodedDating = try encoder.encode(Dating.DatingDataTmp(data: datings[index]))
            
            let url = URL(string: "\(API_URL)/datings/\(datings[index].id)")!
            var request = URLRequest(url: url)
            request.setValue( "Bearer \(KeychainService.standard.read(service: "access_token", account: "lovers")!)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            
            let (_, _) = try await URLSession.shared.upload(for: request, from: encodedDating)
        } catch {
            print("error")
        }
    }
    
    func addDating(dating: Dating) async {
        do {
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            let encodedDating = try encoder.encode(Dating.DatingDataTmp(data: dating))
            
            let url = URL(string: "\(API_URL)/datings/")!
            var request = URLRequest(url: url)
            request.setValue( "Bearer \(KeychainService.standard.read(service: "access_token", account: "lovers")!)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let (_, _) = try await URLSession.shared.upload(for: request, from: encodedDating)
        } catch {
            print("error")
        }
    }
}
