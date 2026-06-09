import XCTest
import UIKit

// Tests for the museum-aesthetic / bilingual refactor. EN is the default at launch.
final class FreeWisperUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // -uitest-reset: SettingsViewModel clears storage so every test starts fresh.
        // -uitest-lang en: force EN so the assertions below stay deterministic.
        app.launchArguments = ["-uitest-reset", "-uitest-lang", "en"]
        app.launch()
    }

    private func bannerButton(containing s: String) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label CONTAINS %@", s)).firstMatch
    }

    // 1) Initial render — masthead, banner, sections all present in EN
    func test_01_initialLaunch() throws {
        XCTAssertTrue(app.staticTexts["Free"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Wisper"].exists)
        XCTAssertTrue(app.staticTexts["No. 001"].exists)
        XCTAssertTrue(app.staticTexts["SETTINGS"].exists)
        XCTAssertTrue(app.staticTexts["v1.0"].exists)
        XCTAssertTrue(app.staticTexts["INITIAL SETUP"].exists)
        XCTAssertTrue(app.staticTexts["Finish setup"].exists)
        XCTAssertTrue(app.staticTexts["0/3"].exists)
        XCTAssertTrue(bannerButton(containing: "Add keyboard in iOS Settings").exists)
        XCTAssertTrue(bannerButton(containing: "Allow Full Access").exists)
        XCTAssertTrue(bannerButton(containing: "Add your Groq API key").exists)
        XCTAssertTrue(app.staticTexts["Groq API key"].exists)
        XCTAssertTrue(app.staticTexts["Transcription model"].exists)
        XCTAssertTrue(app.staticTexts["AI Cleanup"].exists)
        attachScreenshot("01-initial")
    }

    // 2) Tap step 1 → 1/3
    func test_02_tapStep1ProgressesBanner() throws {
        XCTAssertTrue(app.staticTexts["0/3"].waitForExistence(timeout: 5))
        bannerButton(containing: "Add keyboard").tap()
        XCTAssertTrue(app.staticTexts["1/3"].waitForExistence(timeout: 3))
        XCTAssertTrue(bannerButton(containing: "Keyboard installed").exists)
        attachScreenshot("02-step1-done")
    }

    // 3) Tap step 1 + step 2 → 2/3
    func test_03_tapBothInstallSteps() throws {
        XCTAssertTrue(app.staticTexts["0/3"].waitForExistence(timeout: 5))
        bannerButton(containing: "Add keyboard").tap()
        bannerButton(containing: "Allow Full Access").tap()
        XCTAssertTrue(app.staticTexts["2/3"].waitForExistence(timeout: 3))
        XCTAssertTrue(bannerButton(containing: "Network enabled").exists)
        attachScreenshot("03-step2-done")
    }

    // 4) Add API key via the PASTE button (avoids the iOS on-screen keyboard
    // hiding the banner). Verifies 3/3 progression + Clear API key reveal.
    func test_04_typeAPIKeyProgressesBannerAndShowsClear() throws {
        XCTAssertTrue(app.staticTexts["Finish setup"].waitForExistence(timeout: 5))
        bannerButton(containing: "Add keyboard").tap()
        bannerButton(containing: "Allow Full Access").tap()

        // Seed the system pasteboard, then tap the Paste pill.
        UIPasteboard.general.string = "demo-api-key-for-ui-tests"
        let pasteBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'PASTE'"))
            .firstMatch
        XCTAssertTrue(pasteBtn.waitForExistence(timeout: 3))
        pasteBtn.tap()

        XCTAssertTrue(app.staticTexts["Ready to dictate"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["3/3"].exists)
        let clearButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'CLEAR API KEY'")).firstMatch
        swipeUpUntilExists(clearButton, maxSwipes: 4)
        XCTAssertTrue(clearButton.waitForExistence(timeout: 3))
        attachScreenshot("04-all-set")
    }

    // 5) Select Whisper Turbo
    func test_05_selectTranscriptionModel() throws {
        XCTAssertTrue(app.staticTexts["Whisper Large v3 Turbo"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Distil Whisper v3"].exists)
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Whisper Large v3 Turbo'"))
            .firstMatch.tap()
        attachScreenshot("05-turbo-selected")
    }

    // 6) Toggle cleanup → kanji-chip rows + email description appear
    func test_06_toggleCleanupShowsControls() throws {
        XCTAssertTrue(app.staticTexts["Clean up with AI"].waitForExistence(timeout: 5))
        // Scroll the cleanup section into view so the toggle is hittable.
        app.swipeUp()
        let toggle = app.buttons["cleanupToggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 3))
        toggle.tap()

        // After the tap, the kanji style chips should appear.
        let lightStyle = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'LIGHT'")).firstMatch
        let standardStyle = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'STANDARD'")).firstMatch
        let emailStyle = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'EMAIL'")).firstMatch
        swipeUpUntilExists(lightStyle, maxSwipes: 3)
        XCTAssertTrue(lightStyle.waitForExistence(timeout: 3))
        XCTAssertTrue(standardStyle.exists)
        XCTAssertTrue(emailStyle.exists)
        // Mono labels are realized too.
        XCTAssertTrue(app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'CLEANUP MODEL'")).firstMatch.exists)
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS 'GPT-OSS 120B'"))
                      .firstMatch.exists)
        XCTAssertFalse(app.staticTexts["Llama 3.3 70B"].exists)
        attachScreenshot("06-cleanup-on")

        emailStyle.tap()
        XCTAssertTrue(app.staticTexts["Rewrite as clear, email-ready prose."]
                      .waitForExistence(timeout: 2))
        attachScreenshot("06b-email-style")
    }

    // 7) About sheet
    func test_07_aboutSheetOpensAndDismisses() throws {
        XCTAssertTrue(app.staticTexts["Free"].waitForExistence(timeout: 5))
        let row = app.buttons.matching(
            NSPredicate(format: "label CONTAINS %@", "Privacy & data")).firstMatch
        swipeUpUntilExists(row, maxSwipes: 5)
        XCTAssertTrue(row.waitForExistence(timeout: 3))
        row.tap()
        // The sheet contains the eyebrow "ON PRIVACY" + sheet title "Privacy & data" +
        // body text starting "Free Wisper does not collect ...". Match the body text
        // since the eyebrow may share an AX label with the section header.
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'does not collect'"))
                      .firstMatch.waitForExistence(timeout: 3))
        attachScreenshot("07-about-sheet")

        let done = app.buttons["aboutDone"]
        XCTAssertTrue(done.waitForExistence(timeout: 2))
        done.tap()
        let stillThere = done.waitForExistence(timeout: 2)
        XCTAssertFalse(stillThere)
    }

    // 8) Footer
    func test_08_footerCopy() throws {
        XCTAssertTrue(app.staticTexts["Free"].waitForExistence(timeout: 5))
        app.swipeUp(); app.swipeUp(); app.swipeUp()
        XCTAssertTrue(app.staticTexts["Free Wisper · v1.0.0 (1)"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["No accounts. No servers. No tracking."].exists)
        XCTAssertTrue(app.staticTexts["Audio goes straight from your device to Groq."].exists)
        attachScreenshot("08-footer")
    }

    // 9) Switch to 中文 → masthead + section headers flip to Chinese
    func test_09_languageToggle() throws {
        XCTAssertTrue(app.staticTexts["No. 001"].waitForExistence(timeout: 5))
        // The lang toggle cells are Buttons whose label is the visible text.
        let zhBtn = app.buttons["中文"]
        XCTAssertTrue(zhBtn.waitForExistence(timeout: 3))
        zhBtn.tap()
        // Now expect Chinese eyebrows + Chinese section labels
        XCTAssertTrue(app.staticTexts["第 001 号"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["初始设置"].exists)
        XCTAssertTrue(app.staticTexts["完成设置"].exists)
        XCTAssertTrue(app.staticTexts["Groq 密钥"].exists)
        attachScreenshot("09-zh-mode")
    }

    // helpers ---------------------------------------------------------------
    private func attachScreenshot(_ name: String) {
        let shot = XCUIScreen.main.screenshot()
        let att = XCTAttachment(screenshot: shot)
        att.name = name
        att.lifetime = .keepAlways
        add(att)
    }

    private func swipeUpUntilExists(_ element: XCUIElement, maxSwipes: Int) {
        for _ in 0..<maxSwipes where !element.exists {
            app.swipeUp()
        }
    }
}
