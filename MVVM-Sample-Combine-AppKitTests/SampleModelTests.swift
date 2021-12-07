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
        
        model.validate(idText: "id", passwordText: "password")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    actualError = error
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertNil(actualError)
    }
    
    func testValidate_InvalidId() {
        let model = SampleModel()
        var actualError: SampleModelError?
        let expectation = self.expectation(description: "Validate")
        
        model.validate(idText: "", passwordText: "password")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    actualError = error
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(actualError, SampleModelError.invalidId)
    }
    
    func testValidate_InvalidPassword() {
        let model = SampleModel()
        var actualError: SampleModelError?
        let expectation = self.expectation(description: "Validate")
        
        model.validate(idText: "id", passwordText: "")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    actualError = error
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(actualError, SampleModelError.invalidPassword)
    }
    
    func testValidate_InvalidIdAndPassword() {
        let model = SampleModel()
        var actualError: SampleModelError?
        let expectation = self.expectation(description: "Validate")
        
        model.validate(idText: "", passwordText: "")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    actualError = error
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 3)
        XCTAssertEqual(actualError, SampleModelError.invalidIdAndPassword)
    }
}
