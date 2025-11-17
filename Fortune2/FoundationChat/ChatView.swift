//
//  ChatView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 16/11/25.
//

import SwiftUI

struct ChatView: View {
    let initialMessage: String
    
    @StateObject private var sessionManager = ChatSessionManager()
    @State private var prompt: String = ""
    
    var body: some View {
        NavigationView {
                
                VStack(spacing: 0) {
                    ChatMessagesListView(
                        messages: sessionManager.messages,
                        isLoading: sessionManager.isLoading
                    )
                    
                    ChatInputView(
                        prompt: $prompt,
                        isLoading: sessionManager.isLoading
                    ) {
                        sessionManager.sendMessage(prompt)
                        prompt = ""
                    }
                }
            .navigationTitle("✨ Quote Companion")
            .navigationBarTitleDisplayMode(.large)
        }
        
        .onAppear {
            sessionManager.initializeSession(with: initialMessage)
        }
    }
}

#Preview {
    ChatView(initialMessage: "Hello, world!")
}
