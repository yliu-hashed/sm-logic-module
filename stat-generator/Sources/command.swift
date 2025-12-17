//
// command.swift
// stat_generator
//

import Foundation
import ArgumentParser
import SMEDAResult

@main struct stat_generator: ParsableCommand {

    @Argument(help: "Directory of the project", completion: .directory)
    var projectDirectory: String

    @Argument(help: "Path of file to be filled", completion: .file(extensions: [".adoc"]))
    var sourceFile: String

    @Argument(help: "Path to output filled file", completion: .file(extensions: [".adoc"]))
    var destinationFile: String

    @Argument(help: "Tag of the current release version")
    var versionTag: String

    mutating func run() throws {
        let fileManager = FileManager.default
        // get project and other file url
        let projectURL = URL(fileURLWithPath: projectDirectory, isDirectory: true)
            .standardized
            .resolvingSymlinksInPath()

        let templateURL = URL(fileURLWithPath: sourceFile)
        let docOutputURL = URL(fileURLWithPath: destinationFile)
        let reportDirURL = projectURL.appendingPathComponent("reports/", isDirectory: true)

        let reportFiles = try fileManager.contentsOfDirectory(at: reportDirURL, includingPropertiesForKeys: [.isRegularFileKey])

        // read template
        var template = try String(contentsOf: templateURL, encoding: .utf8)

        let decoder = JSONDecoder()

        var cache: [String: [ReportEntry]] = [:]

        func getReportEntries(for prefix: String) throws -> [ReportEntry] {
            // use cache if present
            if let cached = cache[prefix] {
                return cached
            } else {
                // obtain the log url refered by the comment
                let reportURLs = reportFiles.filter { $0.lastPathComponent.hasPrefix(prefix) }
                // read the logs and generate stats
                var reports: [ReportEntry] = []
                for reportURL in reportURLs {
                    let data = try Data(contentsOf: reportURL)
                    let report = try decoder.decode(FullSynthesisReport.self, from: data)

                    let flavor = reportURL.lastPathComponent
                        .trimmingPrefix(prefix)
                        .trimmingPrefix("_")
                        .prefix { $0 != "." }

                    let entry = ReportEntry(flavor: String(flavor), report: report)
                    reports.append(entry)
                }
                let ordered = reorder(reports)
                cache[prefix] = ordered
                return ordered
            }
        }

        // discover and replace comments
        let tableMatcher = #/\/\/ TABLE:[ \t]*([\S]+)\n/#
        let modulePagesMatcher = #/\/\/ MODULE_PAGES\[(\d)\]:[ \t]*([\S]+)\n/#
        let versionTagMatcher = #/!VERSION_TAG_HERE!/#

        try template.replace(tableMatcher) { (match)->String in
            let prefix = String(match.output.1)
            let entries = try getReportEntries(for: prefix)
            if entries.isEmpty { return "N/A\n" }
            return genAdocOverviewTable(prefix: prefix, entries: entries)
        }

        try template.replace(modulePagesMatcher) { (match)->String in
            let level = Int(match.output.1)!
            let prefix = String(match.output.2)
            let entries = try getReportEntries(for: prefix)
            if entries.isEmpty { return "" }
            return genAdocModuleReports(prefix: prefix, entries: entries, level: level)
        }

        template.replace(versionTagMatcher) { (match)->String in
            return versionTag.trimmingCharacters(in: .whitespaces)
        }

        try template.write(to: docOutputURL, atomically: false, encoding: .utf8)
    }
}
