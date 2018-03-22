import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    @IBOutlet var breathView: UIView!

    @IBOutlet var phaseTimeLabel: UILabel!
    @IBOutlet var sessionTimeLabel: UILabel!

    var createViewModel: HomeViewModel.CreateHandler!
    private var viewModel: HomeViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = createViewModel(())
        setupViewModelBindings()
    }

    private func setupViewModelBindings() {
        viewModel.isOngoingSession
            .drive(startButton.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isOngoingSession
            .map { !$0 }
            .drive(breathView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.timeLeftInSession
            .drive(sessionTimeLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.timeLeftInPhase
            .drive(phaseTimeLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.nextPhase
            .drive(onNext: { [weak self] phase in
                guard let strongSelf = self,
                    let phase = phase else { return }
                strongSelf.breathView.backgroundColor = UIColor(hexString: phase.colorHex)
                UIView.animate(withDuration: phase.duration, animations: {
                    switch phase.type {
                    case .inhale:
                        strongSelf.breathView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    case .exhale:
                        strongSelf.breathView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    case .hold: break
                    }
                })
            })
            .disposed(by: disposeBag)
    }

    @IBAction func startButtonPressed() {
        breathView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        viewModel.start()
    }
}

