import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModel: ErrorHandling {
    typealias Input = Void
    typealias CreateHandler = (Input) -> HomeViewModel

    var title: String { get }
}

class HomeViewModelImpl: HomeViewModel {
    typealias Context = HasConfiguration

    private let context: Context

    let title: String
    let errorSubject: PublishSubject<[Error]>? = PublishSubject()

    required init(context: Context, input: HomeViewModel.Input, data: Void?, handlers: Void?) {
        self.context = context
        self.title = "Home Screen"
    }    
}

extension HomeViewModelImpl: ViewModel { }
