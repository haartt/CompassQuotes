//
//  QuoteHistory.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 12/11/25.
//

import SwiftUI

struct QuoteHistoryView: View {
    @ObservedObject var historyManager: QuoteHistoryManager
    @ObservedObject var favoritesManager: FavoritesManager
    
    @Environment(\.dismiss) private var dismiss  // 1. ambiente per chiudere
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                List(historyManager.quotes) { entry in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.dateText)
                                .font(.caption)
                                .foregroundColor(.primary)
                            Text(entry.quote)
                                .font(.body)
                                .foregroundColor(.primary)
                        }

                        Spacer()

                        Button(action: {
                            if favoritesManager.isFavorite(entry) {
                                favoritesManager.removeFromFavorites(entry)
                            } else {
                                favoritesManager.addToFavorites(entry)
                            }
                        }) {
                            Image(systemName: favoritesManager.isFavorite(entry) ? "heart.fill" : "heart")
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.primary.opacity(0.1))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    QuoteHistoryView(historyManager: QuoteHistoryManager(), favoritesManager: FavoritesManager())
}
