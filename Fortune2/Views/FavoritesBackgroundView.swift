//
//  FavoritesBackgroundView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 13/11/25.
//

import SwiftUI

struct FavoritesBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(red: 0.2, green: 0.0, blue: 0.0), location: 0.0),   // very dark red at top
                .init(color: Color(red: 0.9, green: 0.1, blue: 0.1), location: 0.5),   // lighter red at center
                .init(color: Color(red: 0.2, green: 0.0, blue: 0.0), location: 1.0)    // very dark red at bottom
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
