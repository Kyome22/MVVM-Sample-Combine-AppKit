//
//  SampleViewModelTests.swift
//  MVVM-Sample-Combine-AppKitTests
//
//  Created by Takuto Nakamura on 2021/12/07.
//

import XCTest
import AppKit.NSColor
import Combine
@testable import MVVM_Sample_Combine_AppKit

class SampleViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }
    
    func testValidationText_prepend() {
        let viewModel = SampleViewModel()
        var actualText: String?
        let expectation = self.expectation(description: "ValidationText")
        
        viewModel.validationText
            .sink(receiveValue: { text in
                actualText = text
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(actualText, "IDとPasswordを入力してください。")
    }

    func testIdPasswordChanged_finished() {
        let viewModel = SampleViewModel()
        var actualText: String?
        var actualColor: NSColor?
        let expectation = self.expectation(description: "IdPasswordChanged")
        expectation.expectedFulfillmentCount = 3
        
        viewModel.validationText
            .sink(receiveValue: { text in
                actualText = text
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.loadLabelColor
            .sink(receiveValue: { color in
                actualColor = color
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.idPasswordChanged(id: "id", password: "password")
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(actualText, "OK!!!")
        XCTAssertEqual(actualColor, NSColor.green)
    }
    
    func testIdPasswordChanged_failure() {
        let viewModel = SampleViewModel()
        var actualText: String?
        var actualColor: NSColor?
        let expectation = self.expectation(description: "IdPasswordChanged")
        expectation.expectedFulfillmentCount = 3
        
        viewModel.validationText
            .sink(receiveValue: { text in
                actualText = text
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.loadLabelColor
            .sink(receiveValue: { color in
                actualColor = color
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.idPasswordChanged(id: "", password: "")
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(actualText, SampleModelError.invalidIdAndPassword.errorText)
        XCTAssertEqual(actualColor, NSColor.red)
    }
}
