import Foundation

class Program {
    let phases: [Phase]
    let totalDuration: TimeInterval

    init(json: [JSON]) {
        var phases: [Phase] = []
        var total: TimeInterval = 0
        for item in json {
            guard let phase = try? Phase(json: item) else { continue }
            phases.append(phase)
            total += phase.duration
        }
        self.phases = phases
        self.totalDuration = total
    }
}
