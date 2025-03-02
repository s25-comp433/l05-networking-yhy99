//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var games = [Game]()

    var body: some View {
        NavigationStack {
            List(games, id: \.id) { game in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.headline)
                        Text(game.date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.headline)
                            .bold()
                        Text(game.isHomeGame ? "Home" : "Away")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
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
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
