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
    @Published var errMsg: String = ""
    @Published var showingServerAlert: Bool = false
    
    struct Dating: Codable{
        var id: Int
        var date: Date
        var breakfast: Dining
        var lunch: Dining
        var dinner: Dining
        var activities: [Activity]
        var user_id: String
        var remark: String
        
        struct Dining: Codable{
            var type: String = ""
            var restaurant: String = ""
            var location: String = ""
            var cuisine: String = ""
            var area: String = ""
        }
        
        struct Activity: Codable {
            var id: Int
            var location: String = ""
            var description: String = ""
            var isMain: Bool = false
            var area: String = ""
        }
        
        struct DatingFilterSelection{
            var isOnlyShowRemarkRecord: Bool = false
        }
        
        struct Data{
            var id: Int = 0
            var date: Date = Date()
            var breakfast: Dating.Dining = Dating.Dining(type: "早餐")
            var lunch: Dating.Dining = Dating.Dining(type: "午餐")
            var dinner: Dating.Dining = Dating.Dining(type: "晚餐")
            var dining: Dating.Dining = Dating.Dining()
            var activity: Dating.Activity = Dating.Activity(id: 0)
            var activities: [Dating.Activity] = []
            var user_id: String = ""
            var remark: String = ""
        }
    }
    
    struct DatingTest: Codable{
        var id: Int
        var date: Date?
        var breakfast: Dining
        var lunch: Dining
        var dinner: Dining
        var activities: [Activity]
        var user_id: String
        var remark: String
        
        struct Dining: Codable{
            var type: String = ""
            var restaurant: String = ""
            var location: String = ""
            var cuisine: String = ""
            var area: String = ""
        }
        
        struct Activity: Codable {
            var id: Int
            var location: String = ""
            var description: String = ""
            var isMain: Bool = false
            var area: String = ""
        }
    }
    
    func getData() async {
        isLoading = true
        do {
            let url = URL(string: "\(Config.API_URL)/datings/")!
            var request = URLRequest(url: url)
            guard let token = KeychainService.standard.read(service: "access_token", account: "lovers") else {
                isLoading = false
                return
            }
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            let (resData, _) = try await URLSession.shared.data(for: request)
            
            struct Result: Codable
            {
                let success: Bool
                let error_message: String?
                let response: [Dating]?
            }
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let result = try decoder.decode(Result.self, from: resData)
            
            if !result.success {
                isLoading = false
                showingServerAlert = true
                errMsg = result.error_message!
                return
            }
            
            datings = result.response!
            datings.sort {$0.date > $1.date}
        }
        catch {
            isLoading = false
            showingServerAlert = true
            errMsg = "Internal Server Error"
            print("\(error.localizedDescription)")
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
            let url = URL(string: "\(Config.API_URL)/datings/\(id)")!
            var request = URLRequest(url: url)
            request.setValue( "Bearer \(KeychainService.standard.read(service: "access_token", account: "lovers")!)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "DELETE"
            
            let (resData, _) = try await URLSession.shared.data(for: request)
            
            struct Result: Codable
            {
                let success: Bool
                let error_message: String?
            }
            let decoder = JSONDecoder()
            let result = try decoder.decode(Result.self, from: resData)
            
            if !result.success {
                isLoading = false
                showingServerAlert = true
                errMsg = result.error_message!
                return
            }
            
        } catch {
            showingServerAlert = true
            errMsg = "Internal Server Error"
            print("\(error.localizedDescription)")
        }
    }
    
    func updateDating(updatedDatingData: DatingData.Dating.Data) async {
        do {
            struct Request: Codable
            {
                let data: Dating
            }
            
            let index = datings.firstIndex(where: {$0.id == updatedDatingData.id})!
            datings[index].date = updatedDatingData.date
            datings[index].breakfast = updatedDatingData.breakfast
            datings[index].lunch = updatedDatingData.lunch
            datings[index].dinner = updatedDatingData.dinner
            datings[index].activities = updatedDatingData.activities
            datings[index].remark = updatedDatingData.remark
            
            sortDating()
            
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            let encodedDating = try encoder.encode(Request(data: datings[index]))
            
            let url = URL(string: "\(Config.API_URL)/datings/\(datings[index].id)")!
            var request = URLRequest(url: url)
            request.setValue( "Bearer \(KeychainService.standard.read(service: "access_token", account: "lovers")!)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            
            let (resData, _) = try await URLSession.shared.upload(for: request, from: encodedDating)
            
            struct Result: Codable
            {
                let success: Bool
                let error_message: String?
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let result = try decoder.decode(Result.self, from: resData)
            
            if !result.success {
                isLoading = false
                showingServerAlert = true
                errMsg = result.error_message!
                return
            }
        
        } catch {
            showingServerAlert = true
            errMsg = "Internal Server Error"
            print("\(error.localizedDescription)")
        }
    }
    
    func addDating(dating: Dating) async {
        do {
            struct Request: Codable
            {
                let data: Dating
            }
            
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            let encodedDating = try encoder.encode(Request(data: dating))
            
            let url = URL(string: "\(Config.API_URL)/datings/")!
            var request = URLRequest(url: url)
            request.setValue( "Bearer \(KeychainService.standard.read(service: "access_token", account: "lovers")!)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let (resData, _) = try await URLSession.shared.upload(for: request, from: encodedDating)
            
            struct Result: Codable
            {
                let success: Bool
                let error_message: String?
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let result = try decoder.decode(Result.self, from: resData)
            
            if !result.success {
                isLoading = false
                showingServerAlert = true
                errMsg = result.error_message!
                return
            }
            
        } catch {
            showingServerAlert = true
            errMsg = "Internal Server Error"
            print("\(error.localizedDescription)")
        }
    }
}
