//
//  SampleViewModel.swift
//  MVVM-Sample-Combine-AppKit
//
//  Created by Takuto Nakamura on 2021/12/07.
//

import AppKit.NSColor
import Combine

final class SampleViewModel {
    private let model: SampleModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private let validationTextSubject = PassthroughSubject<String, Never>()
    private let loadLabelColorSubject = PassthroughSubject<NSColor, Never>()
    
    var validationText: AnyPublisher<String, Never> {
        return validationTextSubject
            .prepend("IDとPasswordを入力してください。")
            .eraseToAnyPublisher()
    }
    var loadLabelColor: AnyPublisher<NSColor, Never> {
        return loadLabelColorSubject.eraseToAnyPublisher()
    }
    
    init(model: SampleModelProtocol = SampleModel()) {
        self.model = model
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func idPasswordChanged(id: String, password: String) {
        model.validate(idText: id, passwordText: password)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.validationTextSubject.send("OK!!!")
                    self.loadLabelColorSubject.send(NSColor.green)
                case .failure(let error):
                    self.validationTextSubject.send(error.errorText)
                    self.loadLabelColorSubject.send(NSColor.red)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
