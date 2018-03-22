import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModel: ErrorHandling {
    typealias Input = Void
    typealias CreateHandler = (Input) -> HomeViewModel

    var isOngoingSession: Driver<Bool> { get }
    var nextPhase: Driver<Phase?> { get }
    var timeLeftInPhase: Driver<String?> { get }
    var timeLeftInSession: Driver<String?> { get }

    func start()
}

class HomeViewModelImpl: HomeViewModel {
    typealias Context = HasJSONLoader & HasBreathSession
    private let context: Context

    let errorSubject: PublishSubject<[Error]>? = PublishSubject()

    var isOngoingSession: Driver<Bool> { return isOngoingSessionRelay.asDriver() }
    private let isOngoingSessionRelay = BehaviorRelay(value: false)

    var nextPhase: Driver<Phase?> { return nextPhaseSubject.asDriver(onErrorJustReturn: nil) }
    private let nextPhaseSubject = PublishSubject<Phase?>()
    private var currentPhase: Phase?

    var timeLeftInPhase: Driver<String?> {
        return timeLeftInPhaseRelay.asDriver()
            .map { $0?.formattedString ?? nil }
    }
    private let timeLeftInPhaseRelay = BehaviorRelay<TimeInterval?>(value: nil)
    var timeLeftInSession: Driver<String?> {
        return timeLeftInSessionRelay.asDriver()
            .map { $0?.formattedString ?? nil }
    }
    private let timeLeftInSessionRelay = BehaviorRelay<TimeInterval?>(value: nil)

    private var timer: Timer?

    deinit {
        timer?.invalidate()
    }

    required init(context: Context, input: HomeViewModel.Input, data: Void?, handlers: Void?) {
        self.context = context
    }

    func start() {
        self.context.jsonLoader.loadJSON(bundle: Bundle.main, from: "TestProgram", ofType: "json") { [weak self] json in
            self?.startSession(with: json)
        }
    }

    //MARK: - Private helpers

    private func startSession(with json: [JSON]) {
        let program = Program(json: json)
        self.context.breathSession.start(program: program)

        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        timerFired()
    }

    @objc private func timerFired() {
        let phase = self.context.breathSession.currentPhase
        if currentPhase !== phase {
            currentPhase = phase
            nextPhaseSubject.onNext(phase)
        }
        if currentPhase == nil {
            self.context.breathSession.stop()
            timer?.invalidate()
            timer = nil
        }
        isOngoingSessionRelay.accept(self.context.breathSession.status == .running)
        timeLeftInPhaseRelay.accept(self.context.breathSession.timeLeftInPhase)
        timeLeftInSessionRelay.accept(self.context.breathSession.timeLeftInProgram)        
    }
}

extension HomeViewModelImpl: ViewModel { }

extension TimeInterval {
    var formattedString: String {
        let minutes = Int(self / 60)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))

        return String(format: "%02d:%02d", minutes, seconds)
    }
}
