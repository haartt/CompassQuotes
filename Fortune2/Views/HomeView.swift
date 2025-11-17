//
//  HomeView.swift
//  Fortune2
//

import SwiftUI
import Combine

struct HomeView: View {
    @State private var asteriskRotation: Double = 0
    @State private var gradientColors: [Color] = []
    @State private var isHistoryPresented: Bool = false
    
    @StateObject private var provider = QuoteProvider()
    @StateObject private var historyManager = QuoteHistoryManager()
    @StateObject private var gradientEngine = BackgroundGradientEngine()
    
    @ObservedObject var favoritesManager: FavoritesManager  // viene passato da sopra
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                            gradient: Gradient(colors: gradientEngine.colors),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                AsteriskView(rotation: $asteriskRotation)
                    .padding(20)
                
                GreetingView()
                
                QuoteCardView(
                    entry: QuoteEntry(dateText: provider.dateText, quote: provider.quoteText), isInteractive: true,
                    favoritesManager: favoritesManager
                )
                
                Spacer()
                
                HStack {
                    Button(action: { isHistoryPresented.toggle()}) {
                        Image(systemName: "clock")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // share
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        
        .onAppear {
                    gradientEngine.updateGradient()
                    Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
                        gradientEngine.updateGradient()
                        }
        }
        
        .sheet(isPresented: $isHistoryPresented) {
            QuoteHistoryView(
                historyManager: historyManager,
                favoritesManager: favoritesManager)
                .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    HomeView(favoritesManager: FavoritesManager())
        .preferredColorScheme(.dark)
}
