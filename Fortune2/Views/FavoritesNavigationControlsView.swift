//
//  FavoritesNavigationControlsView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 13/11/25.
//

import SwiftUI

struct FavoritesNavigationControlsView: View {
    let currentIndex: Int
    let totalCount: Int
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
            }
            .font(.title2)
            .foregroundColor(currentIndex > 0 ? .white : .white.opacity(0.3))
            .disabled(currentIndex == 0)
            
            Spacer()
            
            Text("\(currentIndex + 1) / \(totalCount)")
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: onNext) {
                Image(systemName: "chevron.right")
            }
            .font(.title2)
            .foregroundColor(currentIndex < totalCount - 1 ? .white : .white.opacity(0.3))
            .disabled(currentIndex == totalCount - 1)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
    }
}
