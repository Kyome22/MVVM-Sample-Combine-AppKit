//
//  SampleViewController.swift
//  MVVM-Sample-Combine-AppKit
//
//  Created by Takuto Nakamura on 2021/12/07.
//

import Cocoa
import Combine

class SampleViewController: NSViewController {
    @IBOutlet weak var idTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var validationLabel: NSTextField!
    
    private let viewModel = SampleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idTextField.placeholderString = "ID"
        passwordTextField.placeholderString = "Password"
        
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        viewModel.validationText
            .sink(receiveValue: { [weak self] text in
                self?.validationLabel.stringValue = text
            })
            .store(in: &cancellables)
        
        viewModel.loadLabelColor
            .sink(receiveValue: { [weak self] color in
                self?.validationLabel.textColor = color
            })
            .store(in: &cancellables)
        
        idTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.makeFirstResponder(idTextField)
    }
}

extension SampleViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        viewModel.idPasswordChanged(id: idTextField.stringValue,
                                    password: passwordTextField.stringValue)
    }
}
