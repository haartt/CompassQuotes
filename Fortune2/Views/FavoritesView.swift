//
//  FavoritesView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 13/11/25.
//

import SwiftUI

struct FavoritesView: View {
    @State private var asteriskRotation: Double = 0
    @ObservedObject var favoritesManager: FavoritesManager
    
    @State private var cards: [QuoteEntry] = []
    @State private var currentIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                FavoritesBackgroundView()
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 20)
                        
                        HeartView(rotation: $asteriskRotation)
                            .padding(20)
                        
                        Text("Favorites")
                            .font(.system(size: 40, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.bottom, 35)
                        
                        if cards.isEmpty {
                            
                            VStack {
                                FavoritesEmptyStateView()
                                    .padding(.vertical, -60)
                            }
                            Spacer()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else {
                            VStack() {
                                FavoritesCardCarouselView(
                                    cards: cards,
                                    currentIndex: $currentIndex,
                                    favoritesManager: favoritesManager,
                                )
                                .padding(.bottom, -80)
                                FavoritesNavigationControlsView(
                                    currentIndex: currentIndex,
                                    totalCount: cards.count,
                                    onPrevious: {
                                        if currentIndex > 0 {
                                            currentIndex -= 1
                                        }
                                    },
                                    onNext: {
                                        if currentIndex < cards.count - 1 {
                                            currentIndex += 1
                                        }
                                    }
                                )
                                
                            }
                        }
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .onAppear {
                cards = favoritesManager.favorites
                currentIndex = 0
            }
            .onChange(of: favoritesManager.favorites) { newFavorites in
                cards = newFavorites
                currentIndex = 0
            }
        }
    }
}

// Preview
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleManager = FavoritesManager()
        sampleManager.favorites = [
        ]
        return FavoritesView(favoritesManager: sampleManager)
    }
}
