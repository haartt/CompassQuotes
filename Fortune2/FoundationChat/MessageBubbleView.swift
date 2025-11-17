//
//  MessageBubbleView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 16/11/25.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        Group {
                            if message.isUser {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue.opacity(0.9),
                                        Color.blue.opacity(0.5)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .background(.thinMaterial)
                            } else {
                                Color.white.opacity(0.3)
                                    .background(.thinMaterial)
                            }
                        }
                    )
                    .cornerRadius(20)
                    .shadow(color: Color.blue.opacity(0.0), radius: 8, x: 0, y: 2)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser {
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    MessageBubbleView(message: .init(content: "Hello World!", isUser: true))
}
