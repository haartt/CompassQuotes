//
//  FavoritesManager.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 15/11/25.
//

import Foundation
import Combine

class FavoritesManager: ObservableObject {
    @Published var favorites: [QuoteEntry] = []

    func addToFavorites(_ entry: QuoteEntry) {
        if !favorites.contains(where: { $0.quote == entry.quote && $0.dateText == entry.dateText }) {
            favorites.append(entry)
        }
    }

    func removeFromFavorites(_ entry: QuoteEntry) {
        favorites.removeAll { $0.quote == entry.quote && $0.dateText == entry.dateText }
    }

    func isFavorite(_ entry: QuoteEntry) -> Bool {
        favorites.contains(where: { $0.quote == entry.quote && $0.dateText == entry.dateText })
    }
    
    func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }

    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([QuoteEntry].self, from: data) {
            favorites = decoded
        }
    }
}
