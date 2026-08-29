import Foundation

struct AppealRecommendation: Identifiable, Hashable {
    let id: String
    let title: String
    let url: URL
    let reason: String
    let priority: Int
    let requiresLogin: Bool
}
