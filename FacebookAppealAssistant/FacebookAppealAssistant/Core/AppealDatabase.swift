import Foundation

/// Curated Meta/Facebook support entry points.
///
/// IMPORTANT: Meta controls eligibility for each form. A URL can exist while
/// still being unavailable to a particular account/session. Historical forms
/// are therefore labeled as legacy rather than guaranteed working appeals.
final class AppealDatabase {

    private struct Entry {
        let id: String
        let title: String
        let url: String
        let reason: String
        let priority: Int
        let requiresLogin: Bool
        let statuses: Set<AccountStatus>
        let legacy: Bool
    }

    private let entries: [Entry] = [
        // Current/general recovery
        Entry(id: "disabled-help", title: "Personal account suspended or disabled", url: "https://www.facebook.com/help/103873106370583", reason: "Official current Help Center guidance for a personal Facebook account that is suspended or disabled.", priority: 120, requiresLogin: true, statuses: [.disabled, .suspended, .accountIntegrity, .reviewPending], legacy: false),
        Entry(id: "hacked", title: "Recover a hacked account", url: "https://www.facebook.com/hacked", reason: "Official recovery entry point for an account that may have been hacked or compromised.", priority: 130, requiresLogin: false, statuses: [.hacked], legacy: false),
        Entry(id: "account-recovery", title: "Account Recovery & Support Hub", url: "https://www.facebook.com/help/1573156092981768", reason: "Official account-recovery hub; the available flow depends on the account state.", priority: 105, requiresLogin: true, statuses: [.disabled, .suspended, .accountIntegrity, .identityVerification, .hacked, .reviewPending, .unknown], legacy: false),
        Entry(id: "login-help", title: "Recover your account if you can't log in", url: "https://www.facebook.com/help/105487009541643", reason: "Official login/recovery troubleshooting flow.", priority: 95, requiresLogin: false, statuses: [.disabled, .suspended, .identityVerification, .hacked, .unknown], legacy: false),
        Entry(id: "help-center", title: "Facebook Help Center", url: "https://www.facebook.com/help/", reason: "Official Facebook Help Center.", priority: 20, requiresLogin: false, statuses: Set(AccountStatus.allCases), legacy: false),

        // Identity / legacy personal-account forms
        Entry(id: "legacy-260749603972907", title: "Personal account disabled — legacy form 260749603972907", url: "https://www.facebook.com/help/contact/260749603972907", reason: "Widely documented legacy personal-account disabled form. Availability is account/session dependent.", priority: 110, requiresLogin: true, statuses: [.disabled, .suspended, .accountIntegrity], legacy: true),
        Entry(id: "legacy-183000765122339", title: "Identity confirmation — legacy form 183000765122339", url: "https://www.facebook.com/help/contact/183000765122339", reason: "Legacy identity-confirmation entry point; use only if Facebook presents an applicable identity flow.", priority: 100, requiresLogin: true, statuses: [.identityVerification, .disabled, .accountIntegrity], legacy: true),
        Entry(id: "legacy-319547548123767", title: "Identity confirmation — legacy form 319547548123767", url: "https://www.facebook.com/help/contact/319547548123767", reason: "Historical identity-confirmation form. Meta may no longer expose it to every account.", priority: 80, requiresLogin: true, statuses: [.identityVerification, .disabled], legacy: true),
        Entry(id: "legacy-317389574998690", title: "Disabled/ineligible — legacy form 317389574998690", url: "https://www.facebook.com/help/contact/317389574998690", reason: "Historical disabled/ineligible form; eligibility is controlled by Meta.", priority: 75, requiresLogin: true, statuses: [.disabled, .suspended], legacy: true),
        Entry(id: "legacy-269030579858086", title: "Disabled/ineligible — legacy form 269030579858086", url: "https://www.facebook.com/help/contact/269030579858086", reason: "Historical disabled/ineligible form.", priority: 70, requiresLogin: true, statuses: [.disabled, .suspended], legacy: true),
        Entry(id: "legacy-122145551250439", title: "Account issue — legacy form 122145551250439", url: "https://www.facebook.com/help/contact/122145551250439", reason: "Historical account-support endpoint.", priority: 65, requiresLogin: true, statuses: [.disabled, .suspended, .unknown], legacy: true),
        Entry(id: "legacy-357439354283890", title: "Login issue — legacy form 357439354283890", url: "https://www.facebook.com/help/contact/357439354283890", reason: "Historical login/support form.", priority: 65, requiresLogin: true, statuses: [.disabled, .suspended, .identityVerification, .hacked], legacy: true),
        Entry(id: "legacy-174964429275926", title: "Account confirmation — legacy form 174964429275926", url: "https://www.facebook.com/help/contact/174964429275926", reason: "Historical account-confirmation endpoint.", priority: 60, requiresLogin: true, statuses: [.identityVerification, .disabled], legacy: true),
        Entry(id: "legacy-283958118330524", title: "Verification problem — legacy form 283958118330524", url: "https://www.facebook.com/help/contact/283958118330524", reason: "Historical verification endpoint.", priority: 60, requiresLogin: true, statuses: [.identityVerification, .disabled], legacy: true),

        // User-supplied historical/current URLs. Categorized narrowly rather than falsely calling all of them account appeals.
        Entry(id: "531795380173090", title: "Facebook form 531795380173090", url: "https://www.facebook.com/help/contact/531795380173090", reason: "Historical Meta/Facebook contact form supplied for this project; eligibility must be determined by Facebook.", priority: 60, requiresLogin: true, statuses: [.disabled, .suspended, .accountIntegrity, .reviewPending, .identityVerification], legacy: true),
        Entry(id: "649167531904667", title: "Facebook form 649167531904667", url: "https://www.facebook.com/help/contact/649167531904667", reason: "Historical form supplied by the user. Do not assume it is a personal-account appeal; Meta controls its current purpose and eligibility.", priority: 45, requiresLogin: true, statuses: [.accountIntegrity, .reviewPending], legacy: true),
        Entry(id: "1417759018475333", title: "Changing Your Name", url: "https://www.facebook.com/help/contact/1417759018475333", reason: "Official form currently associated with changing a Facebook name; not a generic disabled-account appeal.", priority: 30, requiresLogin: true, statuses: [.identityVerification], legacy: false),
        Entry(id: "233841356784195", title: "Birthday change", url: "https://www.facebook.com/help/contact/233841356784195", reason: "Account-information form; not a generic disabled-account appeal.", priority: 25, requiresLogin: true, statuses: [.identityVerification], legacy: false),
        Entry(id: "564493676910603", title: "Facebook form 564493676910603", url: "https://www.facebook.com/help/contact/564493676910603", reason: "Historical contact form supplied for this project; eligibility is account-specific.", priority: 50, requiresLogin: true, statuses: [.disabled, .suspended, .accountIntegrity, .identityVerification], legacy: true),
        Entry(id: "1553947421490701", title: "Facebook form 1553947421490701", url: "https://en-gb.facebook.com/help/contact/1553947421490701", reason: "Historical contact form supplied for this project; eligibility is account-specific.", priority: 50, requiresLogin: true, statuses: [.disabled, .suspended, .identityVerification], legacy: true),
        Entry(id: "1582364792025146", title: "Facebook form 1582364792025146", url: "https://www.facebook.com/help/contact/1582364792025146", reason: "Historical form associated with Meta/Facebook advertising/support workflows rather than a guaranteed personal-account appeal.", priority: 45, requiresLogin: true, statuses: [.accountIntegrity, .reviewPending], legacy: true),
        Entry(id: "418046238594174", title: "Facebook form 418046238594174", url: "https://www.facebook.com/help/contact/418046238594174", reason: "Historical contact form supplied for this project; current eligibility is controlled by Meta.", priority: 45, requiresLogin: true, statuses: [.disabled, .suspended, .accountIntegrity, .reviewPending], legacy: true),
        Entry(id: "157461604368161", title: "Facebook form 157461604368161", url: "https://www.facebook.com/help/contact/157461604368161", reason: "Historical contact form supplied for this project; current eligibility is controlled by Meta.", priority: 45, requiresLogin: true, statuses: [.disabled, .suspended, .accountIntegrity, .reviewPending], legacy: true),
        Entry(id: "244560538958131", title: "Facebook form 244560538958131", url: "https://www.facebook.com/help/contact/244560538958131", reason: "Historical contact form supplied for this project; current eligibility is controlled by Meta.", priority: 45, requiresLogin: true, statuses: [.disabled, .suspended, .accountIntegrity, .reviewPending], legacy: true),

        // Business / advertising support
        Entry(id: "ads-support", title: "Facebook Ads Support", url: "https://www.facebook.com/facebookadsupport/", reason: "Meta/Facebook advertising support entry point.", priority: 80, requiresLogin: true, statuses: [.accountIntegrity, .reviewPending, .contentRestriction], legacy: false),
        Entry(id: "business-community", title: "Meta Business Help Community", url: "https://www.facebook.com/business/help/community?ref=fbb_ens", reason: "Business support community; relevant to business/ad issues, not a guaranteed personal-account appeal.", priority: 55, requiresLogin: true, statuses: [.accountIntegrity, .reviewPending, .contentRestriction], legacy: false),
        Entry(id: "business-chat", title: "Meta Business Support Chat", url: "https://www.facebook.com/business/form/chat?hc_location=ufi", reason: "Business support chat entry point when Meta makes chat available to the account.", priority: 90, requiresLogin: true, statuses: [.accountIntegrity, .reviewPending, .contentRestriction], legacy: false),
        Entry(id: "business-disabled", title: "Troubleshoot a disabled or restricted business account", url: "https://www.facebook.com/business/help/422289316306981", reason: "Official Meta Business Help guidance for restricted/disabled business accounts.", priority: 100, requiresLogin: true, statuses: [.accountIntegrity, .reviewPending, .contentRestriction], legacy: false),

        // Other official appeal categories
        Entry(id: "copyright", title: "Copyright Appeal Form", url: "https://www.facebook.com/help/contact/1653629651334864", reason: "Official copyright appeal form. Only use for a copyright-related decision.", priority: 85, requiresLogin: true, statuses: [.contentRestriction], legacy: false),
        Entry(id: "marketplace", title: "Marketplace Appeals", url: "https://www.facebook.com/help/contact/243266076127593", reason: "Official Marketplace appeal flow. Only use for Marketplace decisions.", priority: 80, requiresLogin: true, statuses: [.contentRestriction], legacy: false),
        Entry(id: "monetization", title: "Monetization Policies Appeal", url: "https://www.facebook.com/help/contact/151371415454526", reason: "Official monetization appeal flow for eligible monetization decisions.", priority: 80, requiresLogin: true, statuses: [.contentRestriction, .reviewPending], legacy: false),
        Entry(id: "consumer-payments", title: "Disabled Consumer Payments Support", url: "https://www.facebook.com/help/contact/162031714239823", reason: "Official support form for a disabled consumer payments account.", priority: 70, requiresLogin: true, statuses: [.contentRestriction, .reviewPending], legacy: false),
        Entry(id: "page-access", title: "Page access issue", url: "https://www.facebook.com/help/contact/957215276032920", reason: "Official form for certain Page admin-access problems, including a hacked admin scenario.", priority: 70, requiresLogin: true, statuses: [.hacked, .contentRestriction], legacy: false),
        Entry(id: "page-group-disabled", title: "Page/Group disabled", url: "https://www.facebook.com/help/contact/258114463744090", reason: "Official form for a disabled Page/Group in the specified policy categories; not for personal profiles.", priority: 60, requiresLogin: true, statuses: [.contentRestriction], legacy: false)
    ]

    func recommendations(for status: AccountStatus) -> [AppealRecommendation] {
        let filtered = entries.filter { $0.statuses.contains(status) }
        let fallback = status == .unknown ? entries.filter { $0.id == "account-recovery" || $0.id == "help-center" } : []
        let selected = filtered.isEmpty ? fallback : filtered

        return selected
            .sorted { $0.priority > $1.priority }
            .compactMap { entry in
                guard let url = URL(string: entry.url) else { return nil }
                let legacyLabel = entry.legacy ? " [LEGACY]" : ""
                return AppealRecommendation(
                    id: entry.id,
                    title: entry.title + legacyLabel,
                    url: url,
                    reason: entry.reason,
                    priority: entry.priority,
                    requiresLogin: entry.requiresLogin
                )
            }
    }
}
