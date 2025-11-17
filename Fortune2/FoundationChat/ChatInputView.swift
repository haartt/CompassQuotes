//
//  ChatInputView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 16/11/25.
//

import SwiftUI

struct ChatInputView: View {
    @Binding var prompt: String
    let isLoading: Bool
    let onSend: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 10) {
                // Glassy text input
                ZStack(alignment: .topLeading) {
                    if prompt.isEmpty {
                        Text("Tell me more.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 17)
                            .padding(.vertical, 15)
                    }

                    TextEditor(text: $prompt)
                        .font(.system(size: 16))
                        .focused($isFocused)
                        .scrollContentBackground(.hidden)
                        .frame(height: 44)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(
                                    isFocused ? Color.blue.opacity(0.4) : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
                )
                
                // Simple glassy send button
                Button(action: {
                    onSend()
                    isFocused = false
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(prompt.isEmpty ? .secondary : .white)
                        .frame(width: 58, height: 58)
                        .background(
                            Group {
                                if prompt.isEmpty {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                } else {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.blue,
                                                    Color.blue.opacity(0.8)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                            }
                        )
                        .shadow(
                            color: prompt.isEmpty ? Color.clear : Color.blue.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                }
                .disabled(prompt.isEmpty || isLoading)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: prompt.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var prompt: String = ""
        
        var body: some View {
            VStack {
                Spacer()
                ChatInputView(
                    prompt: $prompt,
                    isLoading: false
                ) {
                    print("Send: \(prompt)")
                    prompt = ""
                }
            }
            .background(Color(.systemBackground))
        }
    }
    
    return PreviewWrapper()
}





