//
//  DatingEdit.swift
//  Learning
//
//  Created by Derek Yeung on 10/10/2021.
//

import SwiftUI

struct DatingEditView: View {
    @EnvironmentObject var datingData : DatingData
    @Binding var newDatingData: Dating.DatingData
    @Binding var isPresented: Bool
    var isDeleteButtonShow: Bool
    @State private var newActivity: String = ""
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
            DatePicker("Date", selection: $newDatingData.date, displayedComponents: .date)
            Section(header: Text("Meals")) {
                NavigationLink(destination: MealEditView(dining: $newDatingData.breakfast)) {
                    MealRowView(dining: newDatingData.breakfast)
                }
                NavigationLink(destination: MealEditView(dining: $newDatingData.lunch)) {
                    MealRowView(dining: newDatingData.lunch)
                }
                NavigationLink(destination: MealEditView(dining: $newDatingData.dinner)) {
                    MealRowView(dining: newDatingData.dinner)
                }
            }
            Section(header: Text("ACTIVITIES")) {
                ForEach(newDatingData.activities, id: \.id){ activity in
                    NavigationLink(destination: ActivityEditView(activity: binding(for: activity), activities: $newDatingData.activities)) {
                        ActivityRowView(activity: activity)
                    }
                }
                .onDelete(perform: deleteActivityRow)
                HStack {
                    TextField("New Activity", text: $newActivity)
                    Button(action: {
                        withAnimation {
                            var nextId:Int
                            var isMain:Bool
                            if let activity = newDatingData.activities.max(by: {a, b in a.id < b.id}){
                                nextId = activity.id + 1
                                isMain = false
                            } else {
                                nextId = 1
                                isMain = true
                            }
                            newDatingData.activities.append(Dating.Activity(id: nextId, description: newActivity, isMain: isMain))
                            newActivity = ""
                        }
                    })
                    {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newActivity.isEmpty)
                }
            }
            if isDeleteButtonShow {
                HStack {
                    Spacer()
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                    .confirmationDialog("", isPresented: $showingDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            isPresented = false
                            Task {
                                await datingData.deleteDating(id: newDatingData.id)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func binding(for activity: Dating.Activity) -> Binding<Dating.Activity> {
        guard let index = newDatingData.activities.firstIndex(where: { $0.id == activity.id }) else {
            fatalError("Can't find activity in array")
        }
        return $newDatingData.activities[index]
    }
    
    private func deleteActivityRow(at indexSet: IndexSet) {
        var needResetIsMain: Bool = false
        if let index = indexSet.first {
            if newDatingData.activities[index].isMain && newDatingData.activities.count > 1 {
                needResetIsMain = true
            }
        }
        newDatingData.activities.remove(atOffsets: indexSet)
        if needResetIsMain {
            newDatingData.activities[0].isMain = true
        }
    }
}

struct DatingEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatingEditView(newDatingData: .constant(Dating.DatingData()), isPresented: .constant(false), isDeleteButtonShow: true)
        }
    }
}
