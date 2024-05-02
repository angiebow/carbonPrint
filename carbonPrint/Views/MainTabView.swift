//
//  ContentView.swift
//  carbonPrint
//
//  Created by Pelangi Masita Wati on 29/04/24.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                FootprintView()
            }
            .tabItem {
                Image(systemName: "pawprint")
                Text("Footprint")
            }
            
            NavigationView {
                CommunityView()
            }
            .tabItem {
                Image(systemName: "globe.asia.australia")
                Text("Community")
            }
        }
        .accentColor(.blue)
    }
}

struct FootprintView: View {
    var body: some View {
        NavigationSplitViewFoot()
            .navigationTitle("Footprint")
    }
}

struct CommunityView: View {
    var body: some View {
        NavigationSplitViewCom()
            .navigationTitle("Community")
    }
}

struct NavigationSplitViewFoot: View {
    @Environment(\.modelContext) private var context
    
    @Query private var items: [DataItem]
    
    @State private var gasBill: Double = 0
    @State private var electricBill: Double = 0
    @State private var flights: Double = 0
    @State private var recycle: Double = 0
    @State private var carTravel: Double = 0
    @State private var isCalculating: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(){
                    NavigationLink(destination: CalculateView(), isActive: $isCalculating) {
                        HStack{
                            Image(systemName: "carbon.monoxide.cloud")
                                .font(.system(size: 60))
                            Text("Calculate")
                                .font(.title2)
                                .padding()
                        }
                    }
                    .isDetailLink(false)
                    .onTapGesture {
                        isCalculating = true
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: Spacer())
                }
                
                List {
                    ForEach (items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Button {
                                updateItem(item)
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                        }
                    }
                    .onDelete { indexes in
                        for index in indexes {
                            deleteItem(items[index])
                        }
                    }
                }
                
                Button("Save the record") {
                    addItem(footprint: 0)
                }
                
                Section(){
                    HStack{
                        Image(systemName: "chart.xyaxis.line")
                            .font(.system(size: 60))
                        Text("My Footprint")
                            .font(.title2)
                            .padding()
                    }
                }
                
                Section(){
                    HStack{
                        Image(systemName: "fuelpump")
                            .font(.system(size: 60))
                        Text("Gas Bill")
                            .font(.title2)
                            .padding()
                    }
                }
                
                Section(){
                    HStack{
                        Image(systemName: "bolt")
                            .font(.system(size: 60))
                        Text("Electric Bill")
                            .font(.title2)
                            .padding()
                    }
                }
                
                Section(){
                    HStack{
                        Image(systemName: "airplane.departure")
                            .font(.system(size: 60))
                        Text("Flights")
                            .font(.title2)
                            .padding()
                    }
                }
                
                Section(){
                    HStack{
                        Image(systemName: "arrow.3.trianglepath")
                            .font(.system(size: 60))
                        Text("Recycle")
                            .font(.title2)
                            .padding()
                    }
                }
                
                
            }
        }
    }
    
    func addItem(footprint: Double) {
        let item = DataItem(name: "\(footprint)")
        context.insert(item)
    }
    
    func saveFootprint(_ footprint: Double) {
        UserDefaults.standard.set(footprint, forKey: "SavedFootprint")
    }
    
    func deleteItem(_ item: DataItem){
        context.delete(item)
    }
    
    func updateItem(_ item: DataItem) {
        item.name = "Updated"
        try? context.save()
    }
}

struct NavigationSplitViewCom: View {
    @State private var posts: [String] = [
        "Just installed solar panels on my roof! ☀️ #RenewableEnergy",
        "Biked to work today instead of driving! 🚲 #ReduceCarbonFootprint",
        "Started composting food waste to reduce landfill! ♻️ #SustainableLiving",
        "Visited a local farmer's market and bought organic produce! 🥦 #SupportLocal",
        "Planted a tree in my backyard for a greener tomorrow! 🌳 #EcoFriendly"
    ]
    @State private var newPostText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(posts, id: \.self) { post in
                        Text(post)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                    }
                }
                
                Divider()
                
                HStack {
                    TextField("I'm offsetting my carbon footprint by...", text: $newPostText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: addPost) {
                        Text("Post")
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Community")
        }
    }
    
    private func addPost() {
        guard !newPostText.isEmpty else { return }
        posts.append(newPostText)
        newPostText = ""
    }
}

#Preview {
    MainTabView()
}
