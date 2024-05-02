//
//  APIClient.swift
//  planet
//
//  Created by Pelangi Masita Wati on 29/04/24.
//

// API Endpoint: https://api.spaceflightnewsapi.net/v4/articles


import Foundation

struct SpaceData : Codable, Identifiable {
    var id: Int
    var title: String
    var url: String
    var image_url: String
    var news_site: String
    var summary: String
    var published_at: String
}

@MainActor class SpaceAPI : ObservableObject {
    @Published var news: [SpaceData] = []
    
    func getData() {
        guard let url = URL(string: "https://api.spaceflightnewsapi.net/v4/articles?_limit=20") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard let data = data else {
                //let tempErr = error!.localizedDescription
                DispatchQueue.main.async {
                    self.news = [SpaceData(id: 0, title: "Error", url: "Error", image_url: "Error", news_site: "Error", summary: "Try swiping down to refresh as soon as you have internet.", published_at: "Error")]
                }
                return
            }
            
            let spaceData = try! JSONDecoder().decode([SpaceData].self, from: data)
            
            DispatchQueue.main.async {
                print("Loaded new data successfully. Articles \(spaceData.count)")
                self.news = spaceData
            }
        }.resume()
    }
}
