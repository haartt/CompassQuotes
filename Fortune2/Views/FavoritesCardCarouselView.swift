//
//  FavoritesCardCarouselView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 13/11/25.
//

import SwiftUI

struct FavoritesCardCarouselView: View {
    let cards: [QuoteEntry]
    @Binding var currentIndex: Int
    @ObservedObject var favoritesManager: FavoritesManager
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, entry in
                QuoteCardView(
                    entry: entry,
                    isInteractive: true,
                    favoritesManager: favoritesManager
                )
                .frame(maxHeight: 450)
                .padding(.horizontal, 8)
                .padding(.vertical, 30) // Extra vertical padding for shadow
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 510) // Increased to accommodate padding
        .clipped(antialiased: false) // Don't clip shadows
    }
}



