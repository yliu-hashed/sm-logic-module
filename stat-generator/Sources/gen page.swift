//
//  gen page.swift
//  stat-generator
//

import Foundation
import SMEDAResult

func genAdocModuleReports(prefix: String, entries: borrowing [ReportEntry], level: Int) -> String {
    var result: String = ""
    // print each stat
    for entry in entries.lazy {
        result += genAdocModuleReport(
            prefix: prefix,
            name: name(prefix: prefix, flavor: entry.flavor),
            report: entry.report,
            level: level
        )
        result += "<<<\n\n"
    }
    return result
}

private func genSpecificTable(report: borrowing FullSynthesisReport) -> String {
    var result: String = ""
    // print header row
    result += "[cols=\"1,1,1,1,1,1\"]\n"
    result += "|===\n"
    result += "| T~pd~ | Gate Count | Utilization | Width | Height | Length \n\n"
    // print each stat
    result += "| \(timeStr(for: report.timingReport.criticalDepth)) "
    result += "| \(report.complexityReport.gateCount) "
    result += "| \(report.utilizationStr)\n"

    result += "| \(report.placementReport.width)\n"
    result += "| \(report.placementReport.height)\n"
    result += "| \(report.placementReport.depth)\n"

    result += "|===\n\n"
    return result
}

private func genPortDepthTable(delayTable: [String: Int]) -> String {
    let sorted = delayTable.sorted(by: { $0.key < $1.key })
    var result: String = ""
    // print shape row
    let shape = [String](repeating: "1", count: delayTable.count).joined(separator: ",")
    result += "[cols=\"\(shape)\"]\n"
    // print header row
    result += "|===\n"
    for (key, _) in sorted { result += "| T~pd~(\(key)) " }
    result += "\n\n"
    // print each stat
    for (key, _) in sorted { result += "| \(timeStr(for: delayTable[key]!)) " }
    result += "\n|===\n\n"
    return result
}

private func genAdocModuleReport(prefix: String, name: String, report: borrowing FullSynthesisReport, level: Int) -> String {
    let specificTag = specificTag(for: name)
    let sectionTag = sectionTag(for: prefix)

    var result: String = ""
    result += "\(String(repeating: "=", count: level)) \(name.uppercased()) [[\(specificTag)]]\n\n"
    result += "<<\(sectionTag), Go Back to \(prefix.uppercased())>> Overview\n\n"
    result += ".Characteristics\n[%unbreakable]\n"
    result += genSpecificTable(report: report)
    result += ".Inputs Ports Depths *T~pdi~(P)*\n[%unbreakable]\n"
    result += genPortDepthTable(delayTable: report.timingReport.inputTiming)
    result += ".Outputs Ports Depths *T~pdo~(P)*\n[%unbreakable]\n"
    result += genPortDepthTable(delayTable: report.timingReport.outputTiming)

    for (name, surface) in report.placementReport.surfaces {
        result += ".\(name) Surface\n"
        result += genAdocBitfield(from: surface, width: report.placementReport.width)
    }
    return result
}

private func genAdocBitfield(from portMatrix: borrowing PlacementReport.PortSurface, width: Int) -> String {
    var result = "[wavedrom,,svg]\n....\n"
    result += genWavedromBitfield(from: portMatrix, width: width)
    result += "....\n\n"
    return result
}
