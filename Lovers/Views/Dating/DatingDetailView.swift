//
//  DatingDetail.swift
//  Learning
//
//  Created by Derek Yeung on 18/9/2021.
//

import SwiftUI

struct DatingDetailView: View {
    var dating: Dating
    var deleteDating: (Int) async -> Void
    var updateDating: (Dating.DatingData) async -> Void
    var sortDating: () -> Void
    @State private var datingData: Dating.DatingData = Dating.DatingData()
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
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Text(dating.date, style:.date))
        //.navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            datingData.date = dating.date
            datingData.breakfast = dating.breakfast
            datingData.lunch = dating.lunch
            datingData.dinner = dating.dinner
            datingData.activities = dating.activities
            datingData.id = dating.id
        })
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
                DatingEditView(datingData: $datingData, isPresented: $isPresented, deleteDating: self.deleteDating, isDeleteButtonShow: true)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                    isPresented = false
                }, trailing: Button("Done") {
                    isPresented = false
                    sortDating()
                    Task{
                        await updateDating(datingData)
                    }
                }
                        .disabled(datingData.activities.isEmpty)
                )
            }
        }
    }
}

struct DatingDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatingDetailView(dating: datings[0], deleteDating: {(a: Int) in return}, updateDating: {(a: Dating.DatingData) in return},sortDating: {return})
        }
    }
}
