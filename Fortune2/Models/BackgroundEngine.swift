//
//  BackgroundGradientEngine.swift
//  Fortune2
//

import SwiftUI
import Combine

class BackgroundGradientEngine: ObservableObject {
    @Published var colors: [Color] = []

    func updateGradient() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12,
             12..<13 where Calendar.current.component(.minute, from: Date()) < 30:
            colors = [.blue.opacity(0.3), .blue, .cyan.opacity(0.3)]

        case 12..<19:
            colors = [.blue.opacity(0.5), .blue.opacity(0.8), .teal.opacity(0.5)]

        case 19..<22:
            colors = [.purple.opacity(0.6), .pink.opacity(0.7), .purple.opacity(0.4)]

        default:
            colors = [.indigo.opacity(0.9), .purple.opacity(0.95), .black.opacity(1)]
        }
    }
    
}
