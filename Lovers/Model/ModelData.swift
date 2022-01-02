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
        breakfast: Dating.Dining(type: "早餐", restaurant: "ABC Cafe", location: "中環", cuisine: "Japanese"),
        lunch: Dating.Dining(type: "午餐", restaurant: "DEF Cafe2", location: "上水", cuisine: "Chinese"),
        dinner: Dating.Dining(type: "晚餐", restaurant: "Mac", location: "上水", cuisine: "Chinese"),    
        activities: [
            Dating.Activity(id: 1, location: "Yuen Long", description: "Bicycle", isMain: true),
            Dating.Activity(id: 2, location: "Central", description: "Buy Watch", isMain: false)
        ]
    )
]

var data: Dating.DatingData = Dating.DatingData(
    breakfast: Dating.Dining(type: "早餐", restaurant: "ABC Cafe", location: "中環", cuisine: "日本菜"),
    lunch: Dating.Dining(type: "午餐", restaurant: "DEF Cafe2", location: "上水", cuisine: "日本菜"),
    dinner: Dating.Dining(type: "晚餐", restaurant: "Mac Pro", location: "上水", cuisine: "日本菜"),
    dining: Dating.Dining(type: "晚餐", restaurant: "Mac Pro", location: "上水", cuisine: "日本菜"),
    activity: Dating.Activity(id: 1, location: "Yuen Long", description: "Bicycle"),
    activities: [
        Dating.Activity(id: 1, location: "Yuen Long", description: "Bicycle", isMain: true),
        Dating.Activity(id: 2, location: "Central", description: "Buy Watch", isMain: false)
    ]
)
