import Foundation

final class LockDetector {
    func detect(text rawText: String) -> (status: AccountStatus, confidence: Double, signals: [String]) {
        let text = rawText
            .lowercased()
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        var scores: [AccountStatus: Int] = [:]
        var signals = Set<String>()

        func add(_ status: AccountStatus, _ signal: String, _ weight: Int) {
            scores[status, default: 0] += weight
            signals.insert(signal)
        }

        if containsAny(text, ["account integrity", "integrity of your account", "tính toàn vẹn của tài khoản"]) {
            add(.accountIntegrity, "account integrity", 12)
        }
        if containsAny(text, ["account has been disabled", "your account was disabled", "account is disabled", "disabled your account", "we disabled your account", "tài khoản đã bị vô hiệu hóa", "tài khoản của bạn đã bị vô hiệu hóa"]) {
            add(.disabled, "disabled account", 12)
        }
        if containsAny(text, ["account has been suspended", "your account is suspended", "we suspended your account", "suspended your account", "tài khoản bị đình chỉ", "tài khoản của bạn đã bị đình chỉ"]) {
            add(.suspended, "suspended account", 12)
        }
        if containsAny(text, ["confirm your identity", "verify your identity", "identity verification", "confirm identity", "xác nhận danh tính", "xác minh danh tính"]) {
            add(.identityVerification, "identity verification", 12)
        }
        if containsAny(text, ["your account was hacked", "account has been hacked", "account may have been hacked", "account is compromised", "someone accessed your account", "tài khoản bị hack", "tài khoản bị xâm nhập"]) {
            add(.hacked, "hacked / compromised", 12)
        }
        if containsAny(text, ["community standards", "violated our community standards", "content violation", "content was removed", "we removed your content", "vi phạm tiêu chuẩn cộng đồng", "nội dung đã bị gỡ"]) {
            add(.contentRestriction, "community/content policy", 7)
        }
        if containsAny(text, ["appeal", "request a review", "request review", "disagree with this decision", "submit an appeal", "we cannot review this decision", "180 days", "180 ngày", "kháng cáo", "yêu cầu xem xét", "xem xét quyết định"]) {
            add(.reviewPending, "review / appeal language", 4)
        }

        guard let winner = scores.max(by: { $0.value < $1.value }) else {
            return (.unknown, 0, [])
        }

        let second = scores.filter { $0.key != winner.key }.values.max() ?? 0
        let separation = winner.value - second
        let confidence: Double
        switch separation {
        case 8...: confidence = 0.98
        case 5...7: confidence = 0.93
        case 3...4: confidence = 0.86
        case 1...2: confidence = 0.72
        default: confidence = 0.55
        }

        return (winner.key, confidence, Array(signals).sorted())
    }

    private func containsAny(_ text: String, _ phrases: [String]) -> Bool {
        phrases.contains { text.contains($0) }
    }
}
