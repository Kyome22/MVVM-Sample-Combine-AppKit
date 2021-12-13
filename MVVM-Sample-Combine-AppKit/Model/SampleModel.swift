//
//  SampleModel.swift
//  MVVM-Sample-Combine-AppKit
//
//  Created by Takuto Nakamura on 2021/12/07.
//

import Combine

typealias SampleModelResult = Result<Void, SampleModelError>

protocol SampleModelProtocol {
    var validatePublisher: AnyPublisher<SampleModelResult, Never> { get }
    func validate(idText: String, passwordText: String)
}

final class SampleModel: SampleModelProtocol {
    private let validateSubject = PassthroughSubject<SampleModelResult, Never>()
    
    var validatePublisher: AnyPublisher<SampleModelResult, Never> {
        return validateSubject.eraseToAnyPublisher()
    }
    
    func validate(idText: String, passwordText: String) {
        let result: SampleModelResult
        switch (idText.isEmpty, passwordText.isEmpty) {
        case (true, true):
            result = SampleModelResult.failure(.invalidIdAndPassword)
        case (true, false):
            result = SampleModelResult.failure(.invalidId)
        case (false, true):
            result = SampleModelResult.failure(.invalidPassword)
        case (false, false):
            result = SampleModelResult.success(())
        }
        validateSubject.send(result)
    }
}
