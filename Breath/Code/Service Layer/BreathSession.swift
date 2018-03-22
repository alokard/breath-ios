import Foundation

protocol BreathSession {
    var status: SessionStatus { get }
    var currentPhase: Phase? { get }
    var timeLeftInPhase: TimeInterval? { get }
    var timeLeftInProgram: TimeInterval? { get }

    func start(program: Program)
    func stop()
    func pause()
    func resume()
}

enum SessionStatus {
    case stopped
    case paused
    case running
}

class BreathSessionImpl: BreathSession {

    private var currentProgram: Program?
    private(set) var status: SessionStatus

    private var timePassedBeforPause: TimeInterval?
    private var startOfProgram: Date?

    init() {
        status = .stopped
    }

    //MARK: - State vars

    var currentPhase: Phase? {
        guard let program = currentProgram,
            let start = startOfProgram else {
                return nil
        }
        let timeOffset = Date().timeIntervalSince(start)
        return program.phase(by: timeOffset)
    }

    var timeLeftInPhase: TimeInterval? {
        guard let program = currentProgram,
            let start = startOfProgram else {
                return nil
        }
        let timeOffset = Date().timeIntervalSince(start)
        return program.phaseTimeLeft(by: timeOffset)
    }

    var timeLeftInProgram: TimeInterval? {
        guard let program = currentProgram,
            let start = startOfProgram else {
                return nil
        }
        return start.addingTimeInterval(program.totalDuration).timeIntervalSince(Date())
    }

    //MARK: - Control methods

    func start(program: Program) {
        currentProgram = program
        timePassedBeforPause = nil
        status = .running
    }

    func stop() {
        status = .stopped
        currentProgram = nil
        timePassedBeforPause = nil
        startOfProgram = nil
    }

    func pause() {
        guard let startTime = startOfProgram else { return stop() }
        status = .paused
        timePassedBeforPause = Date().timeIntervalSince(startTime)
    }

    func resume() {
        guard let passedTime = timePassedBeforPause else { return stop() }
        startOfProgram = Date().addingTimeInterval(-passedTime)
        timePassedBeforPause = nil
    }
}

extension Program {
    func phase(by timeOffset: TimeInterval) -> Phase? {
        guard timeOffset <= totalDuration else { return nil }
        var duration: TimeInterval = 0
        for phase in phases {
            duration += phase.duration
            if duration >= timeOffset { return phase }
        }
        return nil
    }

    func phaseTimeLeft(by startOffset: TimeInterval) -> TimeInterval? {
        guard startOffset <= totalDuration else { return nil }
        var duration: TimeInterval = 0
        for phase in phases {
            duration += phase.duration
            if duration >= startOffset { return duration - startOffset }
        }
        return nil
    }
}
