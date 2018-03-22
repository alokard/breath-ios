import Foundation

typealias FlowContext = HasConfiguration & HasErrorHandler & HasBreathSession & HasJSONLoader

class Context: FlowContext {
    let configuration: Configuration
    let errorHandler: ErrorHandling
    let breathSession: BreathSession
    let jsonLoader: JSONLoader

    init(configuration: Configuration,
         errorHandler: ErrorHandling,
         breathSession: BreathSession,
         jsonLoader: JSONLoader) {
        self.configuration = configuration
        self.errorHandler = errorHandler
        self.breathSession = breathSession
        self.jsonLoader = jsonLoader
    }
}

