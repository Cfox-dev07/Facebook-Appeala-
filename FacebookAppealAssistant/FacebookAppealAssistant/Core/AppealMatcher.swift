import Foundation

final class AppealMatcher {

    private let database = AppealDatabase()

    func match(
        status: AccountStatus
    ) -> [AppealRecommendation] {

        database
            .recommendations(for: status)
            .sorted {
                $0.priority > $1.priority
            }
    }
}
