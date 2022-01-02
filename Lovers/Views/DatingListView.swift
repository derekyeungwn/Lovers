//
//  DatingList.swift
//  Learning
//
//  Created by Derek Yeung on 18/9/2021.
//

import SwiftUI

struct DatingListView: View {
    @EnvironmentObject var datingData : DatingData
    @State private var isPresented = false
    @State private var searchText = ""
    @State private var newDatingData = Dating.DatingData()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.id){ dating in
                    NavigationLink(destination: DatingDetailView(dating: dating, deleteDating: self.deleteDating, updateDating: self.updateDating, sortDating: self.sortDating)) {
                        DatingRowView(dating: dating)
                    }
                }
            }
            .navigationTitle("Dating")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .toolbar)
            .navigationBarItems(trailing: Button(action: {
                isPresented = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    DatingEditView(datingData: $newDatingData, isPresented: $isPresented, deleteDating: self.deleteDating, isDeleteButtonShow: false)
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
                            let newDating = Dating(
                                id: nextId,
                                date: newDatingData.date,
                                breakfast: newDatingData.breakfast,
                                lunch: newDatingData.lunch,
                                dinner: newDatingData.dinner,
                                activities: newDatingData.activities
                            )
                            datingData.datings.append(newDating)
                            sortDating()
                            newDatingData = Dating.DatingData()
                            Task {
                                await addDating(dating: newDating)
                            }
                        }
                        .disabled(newDatingData.activities.isEmpty)
                        )
                }
            }
            .refreshable {
                do {
                    let url = URL(string: "\(API_URL)/datings/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    
                    let (data, response) = try await URLSession.shared.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        return
                    }
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let a = try decoder.decode(Result.self, from: data)
                    
                    datingData.datings = a.data
                    datingData.datings.sort {$0.date > $1.date}
                } catch {
                    print("error")
                }
            }
        }
    }
    
    var searchResults: [Dating] {
        if searchText.isEmpty {
            return datingData.datings
        } else {
            var filteredDatings: [Dating] = []
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
    
    private func updateDating(updatedDatingData: Dating.DatingData) async {
        do {
            let index = datingData.datings.firstIndex(where: {$0.id == updatedDatingData.id})!
            datingData.datings[index].date = updatedDatingData.date
            datingData.datings[index].breakfast = updatedDatingData.breakfast
            datingData.datings[index].lunch = updatedDatingData.lunch
            datingData.datings[index].dinner = updatedDatingData.dinner
            datingData.datings[index].activities = updatedDatingData.activities
            
            sortDating()
            
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            let encodedDating = try encoder.encode(DatingDataTmp(data: datingData.datings[index]))
            
            let url = URL(string: "\(API_URL)/datings/\(datingData.datings[index].id)")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            
            let (_, _) = try await URLSession.shared.upload(for: request, from: encodedDating)
        } catch {
            print("error")
        }
    }
    
    private func deleteDating(id: Int) async {
        if let index = datingData.datings.firstIndex(where: {$0.id == id}) {
            datingData.datings.remove(at: index)
        }
        do {
            let url = URL(string: "\(API_URL)/datings/\(id)")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "DELETE"
            
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            print("error")
        }
    }
    
    private func sortDating() {
        datingData.datings.sort {$0.date > $1.date}
    }
    
    private func addDating(dating: Dating) async {
        do {
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            let encodedDating = try encoder.encode(DatingDataTmp(data: dating))
            
            let url = URL(string: "\(API_URL)/datings/")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let (_, _) = try await URLSession.shared.upload(for: request, from: encodedDating)
        } catch {
            print("error")
        }
    }
}

struct Result: Codable{
    var data: [Dating]
}

struct DatingList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DatingListView()
                .environmentObject(DatingData())
        }
    }
}
