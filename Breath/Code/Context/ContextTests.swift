import XCTest
import RxSwift
@testable import Breath

class ContextMock: FlowContext {
    let configurationMock = ConfigurationMock()
    var configuration: Configuration { return configurationMock }

    let errorHandlerMock = ErrorHandlingMock()
    var errorHandler: ErrorHandling { return errorHandlerMock }

    let breathSession: BreathSession = BreathSessionImpl()
}

class ContextTests: XCTestCase {
    var sut: Context!
    var loader: JSONLoaderImpl!

    override func setUp() {
        super.setUp()
        loader =  JSONLoaderImpl()
        sut = Context(configuration: ConfigurationMock(),
                      errorHandler: ErrorHandlingMock(),
                      breathSession: BreathSessionImpl())
    }
    
    override func tearDown() {
        sut = nil
        loader = nil
        super.tearDown()
    }

    func testNoMemoryRetainCyclesWithEventSourceOnDeinit() {
        weak var weakSelf = sut
        sut = nil
        XCTAssertNil(weakSelf)
    }
}
