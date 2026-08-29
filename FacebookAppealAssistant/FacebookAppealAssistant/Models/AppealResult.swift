import Foundation

struct AppealResult {
    let status: AccountStatus
    let confidence: Double
    let signals: [String]
    let recommendations: [AppealRecommendation]
    let extractedText: String
}
