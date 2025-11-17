//
//  AsteriskView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 12/11/25.
//

import SwiftUI

struct AsteriskView: View {
    @Binding var rotation: Double
    @State private var lastRotation: Double = 0
    
    var body: some View {
        Image(systemName: "safari")
            .font(.system(size: 100))
            .foregroundColor(.white)
            .rotationEffect(.degrees(rotation))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        rotation = lastRotation + Double(value.translation.width) * 1.2
                    }
                    .onEnded { value in
                        lastRotation = rotation
                        let velocity = value.predictedEndTranslation.width - value.translation.width
                        withAnimation(.interpolatingSpring(stiffness: 8, damping: 3)) {
                            rotation += Double(velocity) * 1.5
                        }
                    }
            )
            .onAppear {
                withAnimation(.easeOut(duration: 3)) {
                    rotation += 360
                    lastRotation = rotation
                }
            }
    }
}
