//
//  ChatMessage.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 16/11/25.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}
