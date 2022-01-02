//
//  DatingEdit.swift
//  Learning
//
//  Created by Derek Yeung on 10/10/2021.
//

import SwiftUI

struct DatingEditView: View {
    @Binding var datingData: Dating.DatingData
    @Binding var isPresented: Bool
    var deleteDating: (Int) async -> Void
    var isDeleteButtonShow: Bool
    @State private var newActivity: String = ""
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
            DatePicker("Date", selection: $datingData.date, displayedComponents: .date)
            Section(header: Text("Meals")) {
                NavigationLink(destination: MealEditView(dining: $datingData.breakfast)) {
                    MealRowView(dining: datingData.breakfast)
                }
                NavigationLink(destination: MealEditView(dining: $datingData.lunch)) {
                    MealRowView(dining: datingData.lunch)
                }
                NavigationLink(destination: MealEditView(dining: $datingData.dinner)) {
                    MealRowView(dining: datingData.dinner)
                }
            }
            Section(header: Text("ACTIVITIES")) {
                ForEach(datingData.activities, id: \.id){ activity in
                    NavigationLink(destination: ActivityEditView(activity: binding(for: activity), activities: $datingData.activities)) {
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
                            if let activity = datingData.activities.max(by: {a, b in a.id < b.id}){
                                nextId = activity.id + 1
                                isMain = false
                            } else {
                                nextId = 1
                                isMain = true
                            }
                            datingData.activities.append(Dating.Activity(id: nextId, description: newActivity, isMain: isMain))
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
                                await deleteDating(datingData.id)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func binding(for activity: Dating.Activity) -> Binding<Dating.Activity> {
        guard let index = datingData.activities.firstIndex(where: { $0.id == activity.id }) else {
            fatalError("Can't find activity in array")
        }
        return $datingData.activities[index]
    }
    
    private func deleteActivityRow(at indexSet: IndexSet) {
        var needResetIsMain: Bool = false
        if let index = indexSet.first {
            if datingData.activities[index].isMain && datingData.activities.count > 1 {
                needResetIsMain = true
            }
        }
        datingData.activities.remove(atOffsets: indexSet)
        if needResetIsMain {
            datingData.activities[0].isMain = true
        }
    }
}

struct DatingEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatingEditView(datingData: .constant(data), isPresented: .constant(false), deleteDating: {(a: Int) in return}, isDeleteButtonShow: true)
        }
    }
}
