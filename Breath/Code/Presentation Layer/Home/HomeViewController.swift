import UIKit

class HomeViewController: UIViewController {

    var createViewModel: HomeViewModel.CreateHandler!
    private var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = createViewModel(())
        setupViewModelBindings()
    }

    private func setupViewModelBindings() {
//        navigationItem.title = viewModel.title
    }
}

