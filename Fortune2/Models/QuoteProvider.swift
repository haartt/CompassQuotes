import Foundation
import Combine
import FoundationModels

class QuoteProvider: ObservableObject {
    @Published var dateText: String = ""
    @Published var quoteText: String = ""

    private var timer: Timer?

    init() {
        generateForToday()
        scheduleMidnightRefresh()
    }

    private func generateForToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"

        dateText = formatter.string(from: Date())

        Task {
            self.quoteText = await self.generateQuote(for: Date())
        }
    }

    private func scheduleMidnightRefresh() {
        timer?.invalidate()

        let now = Date()
        let midnight = Calendar.current.nextDate(
            after: now,
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        )!

        let interval = midnight.timeIntervalSince(now)

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.generateForToday()
            self?.scheduleMidnightRefresh()
        }
    }

    // MARK: - Apple Foundation Model
    private func generateQuote(for date: Date) async -> String {
        do {
            let session = LanguageModelSession()

            let prompt = """
            Write a single, deeply inspiring quote that is exactly 18 words or fewer. The quote should be simple and easy to understand, encouraging reflection, courage, or motivation for the day. Use subtle metaphors or imagery while keeping it concise and relatable. The tone should be uplifting, empowering, and thought-provoking. Do NOT include quotation marks. Write only the sentence itself. IMPORTANT: The quote must be 18 words or less. Don't overdo, keep it simple, but meaningful.
            """

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
}
