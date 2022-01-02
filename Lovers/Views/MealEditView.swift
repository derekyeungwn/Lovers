//
//  MealEdit.swift
//  Learning
//
//  Created by Derek Yeung on 12/10/2021.
//

import SwiftUI

struct MealEditView: View {
    @Binding var dining: Dating.Dining
    @State private var isInit:Bool = false
    @State private var selectedCuisine = ""
    @State private var selectedLocation = ""
    
    let cuisines = [
        "港式",
        "中餐",
        "西餐",
        "台灣菜",
        "日本菜",
        "越南菜",
        "韓國菜",
        "泰國菜",
        "意大利菜",
        "法國菜",
        "中東/地中海菜",
        "中南美菜"
    ]
    
    let locations = [
        "上水",
        "中環"
    ]
    
    var body: some View {
            Form {
                Section {
                    TextField("餐廳", text: $dining.restaurant)
                    TextField("地點", text: $dining.location)
                    Picker("菜式", selection: $dining.cuisine) {
                        ForEach(cuisines, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationTitle(dining.type)
            .navigationBarTitleDisplayMode(.inline)
            //.onAppear(perform: initView)
    }
    
    private func initView() {
    }
}

struct MealEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealEditView(dining: .constant(data.dining))
        }
    }
}
