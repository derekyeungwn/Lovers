//
//  ModelData.swift
//  Learning
//
//  Created by Derek Yeung on 19/9/2021.
//

import Foundation

var datings: [Dating] = [
    Dating(
        id: 1,
        date: Date(),
        breakfast: Dating.Dining(type: "早餐", restaurant: "ABC Cafe", location: "中環", cuisine: "Japanese", area: "旺角"),
        lunch: Dating.Dining(type: "午餐", restaurant: "DEF Cafe2", location: "上水", cuisine: "Chinese", area: "旺角"),
        dinner: Dating.Dining(type: "晚餐", restaurant: "Mac", location: "上水", cuisine: "Chinese", area: "旺角"),    
        activities: [
            Dating.Activity(id: 1, location: "Yuen Long", description: "Bicycle", isMain: true, area: "旺角"),
            Dating.Activity(id: 2, location: "Central", description: "Buy Watch", isMain: false, area: "旺角")
        ],
        user_id: "1"
    )
]
