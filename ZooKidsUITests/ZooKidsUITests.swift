//
//  ZooKidsUITests.swift
//  ZooKidsUITests
//
//  Created by ZooKids Team on 27/11/25.
//

import XCTest

final class ZooKidsUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunchAndNavigation() throws {
        let app = XCUIApplication()
        app.launch()

        // Check if we are on Welcome Screen or Home Screen (depends on persistence)
        // Assuming fresh install or reset state for UI test would be ideal, but we'll check for key elements
        
        if app.buttons["Comenzar Aventura"].exists {
            app.buttons["Comenzar Aventura"].tap()
        }
        
        // Should be on Pet Selection or Home
        // If Pet Selection
        if app.staticTexts["Elige tu Mascota"].exists {
            app.scrollViews.otherElements.images["panda"].tap()
            app.buttons["¡Elegir a Panda!"].tap()
        }
        
        // Now should be on Home View
        XCTAssertTrue(app.staticTexts["Nivel"].exists)
        
        // Navigate to Shop
        app.tabBars.buttons["Tienda"].tap()
        XCTAssertTrue(app.navigationBars["Tienda"].exists)
        
        // Navigate to Games
        app.tabBars.buttons["Juegos"].tap()
        XCTAssertTrue(app.navigationBars["Minijuegos"].exists)
        
        // Navigate back to Home
        app.tabBars.buttons["Inicio"].tap()
        XCTAssertTrue(app.images["panda"].exists)
    }
    
    func testSettingsNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Go to Settings
        app.tabBars.buttons["Ajustes"].tap()
        XCTAssertTrue(app.navigationBars["Ajustes"].exists)
        
        // Check sections
        XCTAssertTrue(app.staticTexts["Mi Compañero de Aventuras"].exists)
        XCTAssertTrue(app.staticTexts["Preferencias de la App"].exists)
        
        // Test Parent Portal Access
        app.buttons["Portal de Padres"].tap()
        XCTAssertTrue(app.staticTexts["Acceso Protegido"].exists)
    }
}
