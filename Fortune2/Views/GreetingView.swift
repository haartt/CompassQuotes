//
//  GreetingView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 12/11/25.
//

import SwiftUI
import Foundation
import Combine

struct GreetingView: View {
    @State private var greeting: String = ""

    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(greeting)
            .font(.system(size: 40, weight: .regular))
            .foregroundColor(.white)
            .padding(.bottom, 60)
            .onAppear {
                updateGreeting()
            }
            .onReceive(timer) { _ in
                updateGreeting()
            }
    }
    
    private func updateGreeting() {
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)
        switch hour {
        case 5..<12:
            greeting = "Good morning"
        case 12..<19:
            greeting = "Good afternoon"
        case 19..<22:
            greeting = "Good evening"
        default:
            greeting = "Enjoy your night"
        }
    }
}
