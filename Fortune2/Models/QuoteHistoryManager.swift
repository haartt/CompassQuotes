//
//  QuoteHistoryManager.swift
//  Fortune2
//
//  Created by Fabio Antonucci on 15/11/25.
//

import Foundation
import Combine
import FoundationModels

struct QuoteEntry: Codable, Identifiable, Equatable {
    var id = UUID()
    let dateText: String
    let quote: String
}

class QuoteHistoryManager: ObservableObject {
    @Published private(set) var quotes: [QuoteEntry] = []
    
    private let maxQuotes = 100
    private let fileName = "quoteHistory.json"
    
    init() {
        loadQuotes()
        
        // Generate 5 default quotes if history is empty
        if quotes.isEmpty {
            Task {
                await generateDefaultQuotes()
            }
        }
    }
    
    private func generateDefaultQuotes() async {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        
        var defaultQuotes: [QuoteEntry] = []
        
        // Different themes/variations for each quote
        let themes = [
            "Focus on courage and overcoming challenges",
            "Emphasize growth and personal transformation",
            "Highlight inner peace and mindfulness",
            "Celebrate resilience and perseverance",
            "Inspire hope and new beginnings"
        ]
        
        // Generate 5 quotes for the past 5 days with different themes
        for (index, daysAgo) in (0..<5).enumerated() {
            let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            let dateText = formatter.string(from: date)
            
            let quoteText = await generateQuote(for: date, theme: themes[index])
            defaultQuotes.append(QuoteEntry(dateText: dateText, quote: quoteText))
        }
        
        await MainActor.run {
            quotes = defaultQuotes
            saveQuotes()
        }
    }
    
    private func generateQuote(for date: Date, theme: String? = nil) async -> String {
        do {
            let session = LanguageModelSession()
            
            var prompt = """
            Write a single, deeply inspiring quote that is exactly 18 words or fewer. The quote should be simple and easy to understand, encouraging reflection, courage, or motivation for the day. Use subtle metaphors or imagery while keeping it concise and relatable. The tone should be uplifting, empowering, and thought-provoking. Do NOT include quotation marks. Write only the sentence itself. IMPORTANT: The quote must be 18 words or less.
            """
            
            // Add theme variation if provided
            if let theme = theme {
                prompt += "\n\nAdditional guidance: \(theme). Make this quote unique and different from other quotes."
            }
            
            let response = try await session.respond(to: prompt).content
            let trimmedResponse = response.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            // Ensure the quote is not longer than 18 words
            let words = trimmedResponse.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
            if words.count > 18 {
                return words.prefix(18).joined(separator: " ")
            }
            
            return trimmedResponse
            
        } catch {
            return "A new day carries a quiet promise."
        }
    }
    
    func addQuote(_ quoteEntry: QuoteEntry) {
        quotes.insert(quoteEntry, at: 0)
        if quotes.count > maxQuotes {
            quotes = Array(quotes.prefix(maxQuotes))
        }
        saveQuotes()
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func saveQuotes() {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try JSONEncoder().encode(quotes)
            try data.write(to: url)
        } catch {
            print("Failed to save quotes: \(error)")
        }
    }
    
    private func loadQuotes() {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: url)
            let loadedQuotes = try JSONDecoder().decode([QuoteEntry].self, from: data)
            quotes = loadedQuotes
        } catch {
            quotes = []
        }
    }

}
