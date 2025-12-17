//
//  naming.swift
//  stat-generator
//

func name(prefix: consuming String, flavor: consuming String) -> String {
    if flavor.isEmpty { return prefix }
    if prefix.isEmpty { return flavor }
    return "\(prefix)_\(flavor)"
}

func specificTag(for name: consuming String) -> String {
    return "SPECIFIC_\(name.uppercased())"
}

func sectionTag(for prefix: consuming String) -> String {
    return prefix.lowercased()
}
