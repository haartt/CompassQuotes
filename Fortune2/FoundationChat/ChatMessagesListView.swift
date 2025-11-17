//
//  ChatMessagesListView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 16/11/25.
//

import SwiftUI

struct ChatMessagesListView: View {
    let messages: [ChatMessage]
    let isLoading: Bool
    var onScrollOffsetChange: ((CGFloat) -> Void)? = nil
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                }
                .frame(height: 0)
                
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubbleView(message: message)
                            .id(message.id)
                    }
                    
                    if isLoading {
                        HStack {
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    }
                }
                .padding()
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                onScrollOffsetChange?(-value)
            }
            .onChange(of: messages.count) { _ in
                if let lastMessage = messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
