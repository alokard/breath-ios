import XCTest
@testable import Breath

class ContextMock: FlowContext {
    let configurationMock = ConfigurationMock()
    var configuration: Configuration { return configurationMock }

    let errorHandlerMock = ErrorHandlingMock()
    var errorHandler: ErrorHandling { return errorHandlerMock }
}

class ContextTests: XCTestCase {
    var eventSource: EventSourceSessionMock!
    var sut: Context!

    override func setUp() {
        super.setUp()
        eventSource = EventSourceSessionMock()
        sut = Context(configuration: ConfigurationMock(),
                      errorHandler: ErrorHandlingMock(),
                      eventSource: eventSource,
                      persistentStore: PersistentStoreServiceMock())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testNoMemoryRetainCyclesWithEventSourceOnDeinit() {
        sut = nil
        XCTAssertTrue(eventSource.stopInvoked)
    }
}
