//
//  ChatSessionManager.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 16/11/25.
//

import Foundation
import FoundationModels
import Combine

@MainActor
class ChatSessionManager: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    
    private var session: LanguageModelSession?
    
    func initializeSession(with initialQuote: String) {
        session = LanguageModelSession()
        
        let explanationPrompt = """
        Reformulate the following quote in 2-3 sentences. Focus on its core meaning and making it clearer to understand or to reflect on. Do not ask questions, just provide the explanation directly. Do not specify what are you explaining, respond in a natural way. Just reformulate in a more concrete way. Keep a friendly tone. Do not exceed 20 words. 
        
        The quote to reformulate is: "\(initialQuote)"
        """
        
        isLoading = true
        
        Task { @MainActor in
            do {
                guard let session = self.session else { 
                    self.isLoading = false
                    return 
                }
                let response = try await session.respond(to: explanationPrompt).content
                
                self.messages.append(ChatMessage(content: response, isUser: false))
                self.isLoading = false
            } catch {
                print("Chat initialization error: \(error)")
                self.messages.append(ChatMessage(content: "I apologize, but I'm having trouble processing that right now. Please try again.", isUser: false))
                self.isLoading = false
            }
        }
    }
    
    func sendMessage(_ userMessage: String) {
        let trimmedMessage = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty, session != nil else { return }
        
        messages.append(ChatMessage(content: trimmedMessage, isUser: true))
        isLoading = true
        
        Task { @MainActor in
            do {
                // Sicuro che session non è nil, quindi possiamo forzare l'unwrap
                let response = try await self.session!.respond(to: trimmedMessage).content
                
                self.messages.append(ChatMessage(content: response, isUser: false))
                self.isLoading = false
            } catch {
                // Stampa dettagliata per debugging
                print("Send message error: \(error) | localized: \(error.localizedDescription)")
                self.messages.append(ChatMessage(
                    content: "I apologize, but I encountered an error. Please try again.",
                    isUser: false
                ))
                self.isLoading = false
            }
        }
    }
}
