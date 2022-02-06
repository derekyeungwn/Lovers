//
//  Dating.swift
//  Learning
//
//  Created by Derek Yeung on 19/9/2021.
//

import Foundation

struct Dating: Codable{
    var id: Int
    var date: Date
    var breakfast: Dining
    var lunch: Dining
    var dinner: Dining
    var activities: [Activity]
    var user_id: String
    
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
    
    struct DatingData{
        var id: Int = 0
        var date: Date = Date()
        var breakfast: Dating.Dining = Dating.Dining(type: "早餐")
        var lunch: Dating.Dining = Dating.Dining(type: "午餐")
        var dinner: Dating.Dining = Dating.Dining(type: "晚餐")
        var dining: Dating.Dining = Dating.Dining()
        var activity: Dating.Activity = Dating.Activity(id: 0)
        var activities: [Dating.Activity] = []
        var user_id: String = "1"
    }
    
    struct Result: Codable{
        var data: [Dating]
    }
    
    struct DatingDataTmp: Codable{
        var data: Dating
    }
}

struct AppCode: Codable{
    var cuisine: [String] = []
    var area: [String] = []
    
    struct Result: Codable{
        var data: [AppCode]
    }
}

struct Login: Codable {
    var token: String = ""
    var user_name: String = ""
    var user_id: String = ""
}
