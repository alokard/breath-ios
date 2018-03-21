import Foundation

protocol FlowsFactory {
    func createMainFlow(with context: FlowContext, navigation: NavigationRouter) -> FlowController
}

class FlowsFactoryImpl: FlowsFactory {
    func createMainFlow(with context: FlowContext, navigation: NavigationRouter) -> FlowController {
        return MainFlowController(context: context, navigation: navigation, flowsFactory: self)
    }
}
