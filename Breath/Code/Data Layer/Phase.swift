import Foundation

enum PhaseType: String {
    case inhale
    case exhale
    case hold
}

enum PhaseParsingError: Error {
    case unknownType
}

class Phase {
    let type: PhaseType
    let duration: TimeInterval
    let colorHex: String

    init(json: JSON) throws {
        guard let type = json.parse("type").flatMap({ PhaseType(rawValue: $0) }) else { throw PhaseParsingError.unknownType }
        self.type = type
        duration = try json.parse("duration")
        colorHex = try json.parse("color")
    }
}
