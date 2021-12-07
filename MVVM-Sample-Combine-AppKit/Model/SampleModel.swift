//
//  SampleModel.swift
//  MVVM-Sample-Combine-AppKit
//
//  Created by Takuto Nakamura on 2021/12/07.
//

import Combine

protocol SampleModelProtocol {
    func validate(idText: String, passwordText: String) -> AnyPublisher<Void, SampleModelError>
}

final class SampleModel: SampleModelProtocol {
    func validate(idText: String, passwordText: String) -> AnyPublisher<Void, SampleModelError> {
        switch (idText.isEmpty, passwordText.isEmpty) {
        case (true, true):
            return Fail(error: SampleModelError.invalidIdAndPassword)
                .eraseToAnyPublisher()
        case (true, false):
            return Fail(error: SampleModelError.invalidId)
                .eraseToAnyPublisher()
        case (false, true):
            return Fail(error: SampleModelError.invalidPassword)
                .eraseToAnyPublisher()
        case (false, false):
            return Just(())
                .setFailureType(to: SampleModelError.self)
                .eraseToAnyPublisher()
        }
    }
}
