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
    
    struct Dining: Codable{
        var type: String = ""
        var restaurant: String = ""
        var location: String = ""
        var cuisine: String = ""
    }
    
    struct Activity: Codable {
        var id: Int
        var location: String = ""
        var description: String = ""
        var isMain: Bool = false
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
    }
}

struct DatingDataTmp: Codable{
    var data: Dating
}