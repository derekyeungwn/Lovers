//
//  DatingDetail.swift
//  Learning
//
//  Created by Derek Yeung on 18/9/2021.
//

import SwiftUI

struct DatingDetailView: View {
    @EnvironmentObject var datingData : DatingData
    var dating: DatingData.Dating
    @State private var newDatingData: DatingData.Dating.Data = DatingData.Dating.Data()
    @State private var isPresented = false
    
    var body: some View {
        List() {
            Section(header: Text("MEALS")) {
                MealRowView(dining: dating.breakfast)
                MealRowView(dining: dating.lunch)
                MealRowView(dining: dating.dinner)
            }
            Section(header: Text("Activities")) {
                ForEach(dating.activities, id: \.id){ activity in
                    ActivityRowView(activity: activity)
                }
            }
            Section(header: Text("Remark")) {
                Text(dating.remark)
                /*TextEditor(text: $newDatingData.remark)
                    .frame(height: 100)*/
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Text(dating.date, style:.date))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            newDatingData.date = dating.date
            newDatingData.breakfast = dating.breakfast
            newDatingData.lunch = dating.lunch
            newDatingData.dinner = dating.dinner
            newDatingData.activities = dating.activities
            newDatingData.id = dating.id
            newDatingData.remark = dating.remark
        })
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
                DatingEditView(newDatingData: $newDatingData, isPresented: $isPresented, isDeleteButtonShow: true)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                    isPresented = false
                }, trailing: Button("Done") {
                    isPresented = false
                    datingData.sortDating()
                    Task{
                        await datingData.updateDating(updatedDatingData: newDatingData)
                    }
                }
                        .disabled(newDatingData.activities.isEmpty)
                )
            }
        }
    }
}

struct DatingDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatingDetailView(dating: datings[0])
        }
        .preferredColorScheme(.dark)
    }
}
