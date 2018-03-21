import Foundation

typealias FlowContext = HasConfiguration & HasErrorHandler

class Context: FlowContext {
    let configuration: Configuration
    let errorHandler: ErrorHandling

    init(configuration: Configuration,
         errorHandler: ErrorHandling) {
        self.configuration = configuration
        self.errorHandler = errorHandler    
    }
}

