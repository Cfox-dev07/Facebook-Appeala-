import Foundation

final class AppealFinder {
    private let detector = LockDetector()
    private let matcher = AppealMatcher()

    func analyze(text: String) -> AppealResult {
        let detection = detector.detect(text: text)
        let recommendations = matcher.match(status: detection.status)

        return AppealResult(
            status: detection.status,
            confidence: detection.confidence,
            signals: detection.signals,
            recommendations: recommendations,
            extractedText: text
        )
    }
}
