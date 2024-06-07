import Foundation
import XCTest


class CircloneUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        setupSnapshot(app)
        app.launch()
    }
    
    func testScreenshots() {
        snapshot("01Shake")
        let window = app.windows.element(boundBy: 0)
        window.tap()
        snapshot("02Circles")
    }
}
