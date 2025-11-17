//
//  ContentView.swift
//  Fortune2
//

import SwiftUI

struct ContentView: View {
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some View {
        
        // TabBar container
        TabView {
            HomeView(favoritesManager: favoritesManager)
                .tabItem {
                    Image(systemName: "safari")
                    Text("Home")
                }
            
            FavoritesView(favoritesManager: favoritesManager)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
        }
    }
}

#Preview {
    ContentView()
}
