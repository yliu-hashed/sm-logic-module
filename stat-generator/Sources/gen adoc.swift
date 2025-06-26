//
//  gen adoc.swift
//  stat-generator
//

import SMEDAResult

func timeStr(for depth: Int) -> String {
    let combDepthSecs = (Double(depth) / 40.0)
    return "\(depth)(\(combDepthSecs)s)"
}

func timeStr(for depth: Int?) -> String {
    guard let depth = depth else { return "N/A" }
    let combDepthSecs = (Double(depth) / 40.0)
    return "\(depth)(\(combDepthSecs)s)"
}

func numStr(for value: Int?) -> String {
    guard let value = value else { return "N/A" }
    return "\(value)"
}

func genSimpleTable(prefix: String, entries: borrowing [ReportEntry]) -> String {
    var result: String = ""
    // print header row
    result += "[cols=\"3,1,1,1\"]\n"
    result += "|===\n"
    result += "| Flavor | T~pd~ | Gate Count | Utilization\n\n"
    // print each stat
    for entry in entries.lazy {
        let tag = "\(prefix)_\(entry.flavor)".uppercased()
        result += "| \(entry.flavor) (<<\(tag)>>) "
        result += "| \(timeStr(for: entry.report.timingReport.criticalDepth)) "
        result += "| \(entry.report.complexityReport.gateCount) "
        result += "| \(entry.report.utilizationStr)\n"
    }
    result += "|===\n"
    return result
}
