//
//  FavoritesEmptyStateView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 13/11/25.
//

import SwiftUI

struct FavoritesEmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text("No favorites yet")
                .font(.system(size: 20))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(minHeight: 400)
        .padding(.vertical, 40)
    }
}

