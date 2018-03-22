import Foundation
import RxSwift

class ApplicationController: ErrorHandling {
    private let context: Context
    private let navigationRouter: NavigationRouter
    private let flowsFactory: FlowsFactory

    private let disposeBag = DisposeBag()

    init(navigation: NavigationRouter, flowsFactory: FlowsFactory = FlowsFactoryImpl()) {
        self.flowsFactory = flowsFactory
        navigationRouter = navigation

        let configuration = ConfigurationImpl(environment: AppEnvironment())
        let errorHandler = SimpleErrorHandler()
        let breathSession = BreathSessionImpl()
        let jsonLoader = JSONLoaderImpl()

        context = Context(configuration: configuration,
                          errorHandler: errorHandler,
                          breathSession: breathSession,
                          jsonLoader: jsonLoader)
    }

    func setupWithLaunchOptions(_ launchOptions: [AnyHashable: Any]?) {
        let mainFlow = flowsFactory.createMainFlow(with: context, navigation: navigationRouter)
        mainFlow.start()
    }

    func didBecomeActive() {

    }

    func willResignActive() {

    }
}
