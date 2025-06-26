//
//  report entry.swift
//  stat-generator
//

import Foundation
import SMEDAResult

struct ReportEntry {
    var flavor: String
    var report: FullSynthesisReport
}

extension FullSynthesisReport {
    var utilizationStr: String {
        let utilization = placementReport.utilization
        guard utilization != 0 else { return "N/A" }
        return String(format: "%.2f", utilization * 100) + "%"
    }
}

private func compare(lhs: String, rhs: String) -> Bool {
    let matcher = #/[\D]+|[\d]+/#
    let lhsTokens = lhs.matches(of: matcher)
    let rhsTokens = rhs.matches(of: matcher)
    if lhsTokens.count != rhsTokens.count { return lhs < rhs }

    for i in 0..<lhsTokens.count {
        let lhsToken = lhsTokens[i].output;
        let rhsToken = rhsTokens[i].output;
        if lhsToken == rhsToken { continue }

        if let lhsInt = Int(lhsToken),
           let rhsInt = Int(rhsToken) {
            return lhsInt < rhsInt
        }

        return lhsToken < rhsToken
    }

    return lhs < rhs
}

func reorder(_ entries: consuming [ReportEntry]) -> [ReportEntry] {
    return entries.sorted { compare(lhs: $0.flavor, rhs: $1.flavor) }
}
