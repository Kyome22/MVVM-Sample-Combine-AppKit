//
//  SampleModelTest.swift
//  MVVM-Sample-Combine-AppKitTests
//
//  Created by Takuto Nakamura on 2021/12/07.
//

import XCTest
import Combine
@testable import MVVM_Sample_Combine_AppKit

class SampleModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }
    
    func testValidate_OK() {
        let model = SampleModel()
        var actualError: SampleModelError?
        let expectation = self.expectation(description: "Validate")
        
        model.validatePublisher
            .sink(receiveValue: { result in
                if case .failure(let error) = result {
                    actualError = error
                }
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        model.validate(idText: "id", passwordText: "password")
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertNil(actualError)
    }
    
    func testValidate_InvalidId() {
        let model = SampleModel()
        var actualError: SampleModelError?
        let expectation = self.expectation(description: "Validate")
        
        model.validatePublisher
            .sink(receiveValue: { result in
                if case .failure(let error) = result {
                    actualError = error
                }
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        model.validate(idText: "", passwordText: "password")
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(actualError, SampleModelError.invalidId)
    }
    
    func testValidate_InvalidPassword() {
        let model = SampleModel()
        var actualError: SampleModelError?
        let expectation = self.expectation(description: "Validate")
        
        model.validatePublisher
            .sink(receiveValue: { result in
                if case .failure(let error) = result {
                    actualError = error
                }
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        model.validate(idText: "id", passwordText: "")
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(actualError, SampleModelError.invalidPassword)
    }
    
    func testValidate_InvalidIdAndPassword() {
        let model = SampleModel()
        var actualError: SampleModelError?
        let expectation = self.expectation(description: "Validate")
        
        model.validatePublisher
            .sink(receiveValue: { result in
                if case .failure(let error) = result {
                    actualError = error
                }
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        model.validate(idText: "", passwordText: "")
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(actualError, SampleModelError.invalidIdAndPassword)
    }
}
