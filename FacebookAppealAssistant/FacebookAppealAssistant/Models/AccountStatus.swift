import Foundation

enum AccountStatus: String, CaseIterable, Codable {
    case disabled
    case suspended
    case accountIntegrity
    case identityVerification
    case hacked
    case contentRestriction
    case reviewPending
    case unknown

    var displayName: String {
        switch self {
        case .disabled: return "Tài khoản bị vô hiệu hóa"
        case .suspended: return "Tài khoản bị đình chỉ"
        case .accountIntegrity: return "Account Integrity"
        case .identityVerification: return "Xác minh danh tính"
        case .hacked: return "Tài khoản có thể bị xâm nhập"
        case .contentRestriction: return "Hạn chế nội dung"
        case .reviewPending: return "Đang chờ xem xét"
        case .unknown: return "Không xác định"
        }
    }

    var icon: String {
        switch self {
        case .disabled, .suspended, .accountIntegrity: return "lock.fill"
        case .identityVerification: return "person.text.rectangle"
        case .hacked: return "exclamationmark.shield.fill"
        case .contentRestriction: return "exclamationmark.triangle.fill"
        case .reviewPending: return "clock.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
}
