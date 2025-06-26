//
//  gen wavedrom.swift
//  stat-generator
//

import SMEDAResult

func genWavedromBitfield(from portMatrix: borrowing PlacementReport.PortSurface, width: Int) -> String {
    let height = portMatrix.count

    var result = "{ reg: [\n"

    func emit(msb: Int = 0, lsb: Int = 0, name: String? = nil, type: Int? = nil) {
        result += "  { bits: \(abs(msb - lsb) + 1), "
        if let name = name {
            if msb == lsb {
                if msb == 0 {
                    result += "name: '\(name)', "
                } else {
                    result += "name: '\(name)[\(msb)]', "
                }
            } else {
                result += "name: '\(name)[\(msb):\(lsb)]', "
            }
        }
        if let type = type {
            result += "type: \(type), "
        }
        result += "},\n"
    }

    func emit(space: Int) {
        result += "  { bits: \(space), type: 0 },\n"
    }

    for portLine in portMatrix.lazy {
        var index: Int = 0
        for port in portLine {
            if port.offset > index {
                emit(space: port.offset - index)
            }
            let length = abs(port.msb - port.lsb) + 1
            emit(msb: port.msb, lsb: port.lsb, name: port.name)
            index = port.offset + length
        }
        if width > index {
            emit(space: width - index)
        }
    }

    result += "], config: { lanes: \(height), bits: \(width * height), compact: true } }\n"
    return result
}
