//
//  ActivityEdit.swift
//  Learning
//
//  Created by Derek Yeung on 30/10/2021.
//

import SwiftUI

struct ActivityEditView: View {
    @Binding var activity: Dating.Activity
    @Binding var activities: [Dating.Activity]
    @EnvironmentObject var loginData : LoginData
    @State private var selectedArea = ""
    
    var body: some View {
        Form {
            Section {
                TextField("活動", text: $activity.description)
                Picker("地區", selection: $activity.area) {
                    ForEach(loginData.appCode.area, id: \.self) {
                        Text($0)
                    }
                }
                TextField("地點", text: $activity.location)
                Toggle(isOn: $activity.isMain) {
                    Text("重點活動")
                }
                .disabled(activity.isMain)
                .onChange(of: activity.isMain) { value in
                    for index in activities.indices {
                        if activities[index].isMain == true && activities[index].id != activity.id {
                            activities[index].isMain = false
                        }
                    }
                }
            }
        }
        //.navigationTitle(dining.type)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ActivityEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActivityEditView(activity: .constant(data.activity), activities: .constant(data.activities))
        }
    }
}
