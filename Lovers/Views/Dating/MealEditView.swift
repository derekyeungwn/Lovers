//
//  MealEdit.swift
//  Learning
//
//  Created by Derek Yeung on 12/10/2021.
//

import SwiftUI

struct MealEditView: View {
    @Binding var dining: Dating.Dining
    @EnvironmentObject var loginData : LoginData
    @State private var isInit:Bool = false
    @State private var selectedCuisine = ""
    @State private var selectedLocation = ""
    @State private var selectedArea = ""
    
    var body: some View {
            Form {
                Section {
                    TextField("餐廳", text: $dining.restaurant)
                    Picker("地區", selection: $dining.area) {
                        ForEach(loginData.appCode.area, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("地點", text: $dining.location)
                    Picker("菜式", selection: $dining.cuisine) {
                        ForEach(loginData.appCode.cuisine, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationTitle(dining.type)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func initView() {
    }
}

struct MealEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealEditView(dining: .constant(data.dining))
                .environmentObject(LoginData())
        }
    }
}
