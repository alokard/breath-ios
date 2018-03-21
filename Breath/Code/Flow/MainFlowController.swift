import UIKit

class MainFlowController: FlowController {
    private let context: FlowContext
    private let navigation: NavigationRouter
    private let flowsFactory: FlowsFactory

    init(context: FlowContext, navigation: NavigationRouter, flowsFactory: FlowsFactory) {
        self.context = context
        self.navigation = navigation
        self.flowsFactory = flowsFactory
    }

    func start() {
        showStartScreen()
    }

    func showStartScreen() {
        let controller = HomeViewController.from(storyboard: .main)
        controller.createViewModel = HomeViewModelImpl.create(context: context, data: nil, handlers: nil)
        navigation.setViewControllers([controller], animated: false)
    }
}
