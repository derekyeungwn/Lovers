//
//  DatingList.swift
//  Learning
//
//  Created by Derek Yeung on 18/9/2021.
//

import SwiftUI

struct DatingListView: View {
    @EnvironmentObject var loginData : LoginData
    @StateObject var datingData: DatingData
    @State private var isPresented = false
    @State private var isPresentFilter = false
    @State private var searchText = ""
    @State private var newDatingData = DatingData.Dating.Data()
    @State private var datingFilterSelection = DatingData.Dating.DatingFilterSelection()
    
    init() {
        self._datingData = StateObject(wrappedValue: DatingData())
    }
    
    var body: some View {
        ZStack() {
            NavigationView {
                VStack(){
                    HStack{
                        Spacer()
                        Button(action:{
                            isPresentFilter = true
                        }) {
                            Label("篩選", systemImage: "slider.horizontal.3")
                        }
                        .padding(.trailing, 20)
                    }
                    List {
                        if datingFilterSelection.isOnlyShowRemarkRecord {
                            ForEach(searchResults.filter {$0.remark != ""}, id: \.id){ dating in
                                NavigationLink(destination: DatingDetailView(dating: dating)) {
                                    DatingRowView(dating: dating)
                                }
                            }
                        }else{
                            ForEach(searchResults, id: \.id){ dating in
                                NavigationLink(destination: DatingDetailView(dating: dating)) {
                                    DatingRowView(dating: dating)
                                }
                            }
                        }
                    }
                    .listStyle(InsetListStyle())
                    .navigationTitle("Dating(\(datingData.datings.count))")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $searchText, placement: .toolbar)
                    .navigationBarItems(trailing: Button(action: {
                        isPresented = true
                    }) {
                        Image(systemName: "plus")
                    })
                    .fullScreenCover(isPresented: $isPresentFilter) {
                        NavigationView {
                            DatingListFilterView(isPresentFilter: $isPresentFilter, datingFilterSelection: $datingFilterSelection)
                            .navigationBarTitle("篩選條件", displayMode: .inline)
                            .navigationBarItems(leading: Button(action:{
                                isPresentFilter = false
                            }){Image(systemName: "xmark")},trailing: Button("重設") {
                                datingFilterSelection.isOnlyShowRemarkRecord = false
                            })
                        }
                    }
                    .sheet(isPresented: $isPresented) {
                        NavigationView {
                            DatingEditView(newDatingData: $newDatingData, isPresented: $isPresented, isDeleteButtonShow: false)
                                .navigationBarTitle("", displayMode: .inline)
                                .navigationBarItems(leading: Button("Dismiss") {
                                    isPresented = false
                                }, trailing: Button("Add") {
                                    isPresented = false
                                    var nextId:Int
                                    if let dating = datingData.datings.max(by: {a, b in a.id < b.id}){
                                        nextId = dating.id + 1
                                    } else {
                                        nextId = 1
                                    }
                                    let newDating = DatingData.Dating(
                                        id: nextId,
                                        date: newDatingData.date,
                                        breakfast: newDatingData.breakfast,
                                        lunch: newDatingData.lunch,
                                        dinner: newDatingData.dinner,
                                        activities: newDatingData.activities,
                                        user_id: loginData.appCode.user_id,
                                        remark: newDatingData.remark
                                    )
                                    datingData.datings.append(newDating)
                                    datingData.sortDating()
                                    newDatingData = DatingData.Dating.Data()
                                    Task {
                                        await datingData.addDating(dating: newDating)
                                    }
                                }
                                .disabled(newDatingData.activities.isEmpty)
                                )
                        }
                    }
                    .refreshable {
                        await datingData.getData()
                    }
                    Spacer()
                }
            }
            .alert("Could not connect to the server", isPresented: $datingData.showingServerAlert) {
                Button(action: {
                    datingData.showingServerAlert = false
                }) {
                    Text("OK")
                }
            }
            .task {
                await datingData.getData()
            }
            .environmentObject(datingData)
            if datingData.isLoading {
                LoadingView()
            }
        }
    }
    
    var searchResults: [DatingData.Dating] {
        if searchText.isEmpty {
            return datingData.datings
        } else {
            var filteredDatings: [DatingData.Dating] = []
            for dating in datingData.datings {
                if dating.lunch.restaurant.contains(searchText) || dating.dinner.restaurant.contains(searchText) || dating.breakfast.restaurant.contains(searchText){
                    filteredDatings.append(dating)
                    continue
                }
                if dating.lunch.location.contains(searchText) || dating.dinner.location.contains(searchText) || dating.breakfast.location.contains(searchText){
                    filteredDatings.append(dating)
                    continue
                }
                for activity in dating.activities {
                    if activity.description.contains(searchText) || activity.location.contains(searchText){
                        filteredDatings.append(dating)
                        continue
                    }
                }
            }
            return filteredDatings
        }
    }
}

struct DatingList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DatingListView()
                .environmentObject(LoginData())
                .preferredColorScheme(.dark)
        }
    }
}
