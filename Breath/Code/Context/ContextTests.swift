import XCTest
@testable import Breath

class ContextMock: FlowContext {
    let configurationMock = ConfigurationMock()
    var configuration: Configuration { return configurationMock }

    let errorHandlerMock = ErrorHandlingMock()
    var errorHandler: ErrorHandling { return errorHandlerMock }
}

class ContextTests: XCTestCase {
    var sut: Context!

    override func setUp() {
        super.setUp()
        sut = Context(configuration: ConfigurationMock(),
                      errorHandler: ErrorHandlingMock())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testNoMemoryRetainCyclesWithEventSourceOnDeinit() {
        weak var weakSelf = sut
        sut = nil
        XCTAssertNil(weakSelf)
    }
}
