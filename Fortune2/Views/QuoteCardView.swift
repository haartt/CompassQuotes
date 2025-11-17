//
//  QuoteCardView.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 12/11/25.
//

import SwiftUI

struct QuoteCardView: View {
    @State private var dragAmount: CGSize = .zero
    @State private var isDragging: Bool = false
    @State private var textHeight: CGFloat = 0
    @State private var showChatView: Bool = false
    
    let entry: QuoteEntry
    let isInteractive: Bool
    
    @ObservedObject var favoritesManager: FavoritesManager
    
    var body: some View {
        
        GeometryReader { geometry in
            
            // Actual card:
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                
                    .fill(Color.black.opacity(0.6))
                
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .frame(height: textHeight + 80)
                
                    .overlay(
                        VStack(alignment: .leading, spacing: 16) {
                            Text(entry.dateText)
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text(entry.quote)
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .onAppear {
                                                textHeight = geo.size.height + 80
                                            }
                                            .onChange(of: geo.size.height) {
                                                textHeight = geo.size.height + 80
                                            }
                                    }
                                )
                            
                            HStack(){
                                
                                // AI button:
                                Button(action: {
                                    showChatView = true
                                }) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .frame(width: 56, height: 56)
                                        .background(Color.white.opacity(0.15))
                                        .clipShape(Circle())
                                }
                                .sheet(isPresented: $showChatView) {
                                    ChatView(initialMessage: entry.quote)
                                        .presentationDetents([.medium, .large])
                                }
                                
                                Spacer()
                                
                                // Add to favorites button:
                                Button(action: {
                                    if favoritesManager.isFavorite(entry) {
                                        favoritesManager.removeFromFavorites(entry)
                                    } else {
                                        favoritesManager.addToFavorites(entry)
                                    }
                                }){
                                    Image(systemName: favoritesManager.isFavorite(entry) ? "heart.fill" : "heart")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Color.white.opacity(0.15))
                                    .clipShape(Circle())
                                    }
                            }
                        }
                        .padding(.horizontal, 32)
                    )
            }
            .padding(.horizontal, 24)
        }
        .modifier(InteractiveCardModifier(isInteractive: isInteractive,
                                          dragAmount: $dragAmount,
                                          isDragging: $isDragging))
    }
}

struct InteractiveCardModifier: ViewModifier {
    let isInteractive: Bool
    @Binding var dragAmount: CGSize
    @Binding var isDragging: Bool

    func body(content: Content) -> some View {
        if isInteractive {
            content
                .rotation3DEffect(
                    .degrees(max(min(Double((dragAmount.width + dragAmount.height) / 25), 4), -4)),
                    axis: (x: 1, y: 1, z: 0)
                )
                .offset(x: dragAmount.width / 20, y: dragAmount.height / 20)
                .scaleEffect(isDragging ? 1.01 : 1)
                .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.6, blendDuration: 0.6), value: dragAmount)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragAmount = CGSize(width: value.translation.width / 3,
                                                height: value.translation.height / 3)
                            isDragging = true
                        }
                        .onEnded { _ in
                            dragAmount = .zero
                            isDragging = false
                        }
                )
        } else {
            content
        }
    }
}

#Preview {
    QuoteCardView(entry: QuoteEntry(dateText: "November 10, 2020", quote: "Hello World! ttttttttttttt"), isInteractive: true, favoritesManager: FavoritesManager())
}

