//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

// 定义 JSON 数据结构
struct Game: Codable, Identifiable {
    var id: Int
    var team: String // "Men" or "Women"
    var opponent: String
    var date: String
    var isHomeGame: Bool
    var score: Score

    struct Score: Codable {
        var unc: Int
        var opponent: Int
    }
}

struct ContentView: View {
    @State private var games = [Game]()
    
    var body: some View {
        NavigationView {
            List(games) { game in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.headline)
                        
                        Text(game.date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.headline)
                            .bold()
                        
                        Text(game.isHomeGame ? "Home" : "Away")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(10)
            }
            .navigationTitle("UNC Basketball")
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([Game].self, from: data)
            
            DispatchQueue.main.async {
                self.games = decodedResponse
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
