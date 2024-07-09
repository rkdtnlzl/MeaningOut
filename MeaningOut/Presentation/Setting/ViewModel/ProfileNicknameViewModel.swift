//
//  ProfileNicknameViewModel.swift
//  MeaningOut
//
//  Created by 강석호 on 7/9/24.
//

import Foundation

class ProfileNicknameViewModel {
    
    var inputNickname: Observable<String?> = Observable("")
    
    var outputValidationText = Observable("")
    var outputValid = Observable(false)
    
    init() {
        inputNickname.bind { _ in
            self.validation()
        }
    }
    
    private func validation() {
        
        guard let nickname = inputNickname.value else { return }
        
        let specialLiterals = CharacterSet(charactersIn: "@#$%")
        let numbers = CharacterSet.decimalDigits
        
        if nickname.count < 2 || nickname.count > 9 {
            outputValidationText.value = StringLiterals.LabelText.NickNameStatus.numberCase
            outputValid.value = false
        } else if nickname.rangeOfCharacter(from: specialLiterals) != nil {
            outputValidationText.value = StringLiterals.LabelText.NickNameStatus.specialLiteralsCase
            outputValid.value = false
        } else if nickname.rangeOfCharacter(from: numbers) != nil {
            outputValidationText.value = StringLiterals.LabelText.NickNameStatus.numberOfLiteralsCase
            outputValid.value = false
        } else {
            outputValidationText.value = StringLiterals.LabelText.NickNameStatus.rightCase
            outputValid.value = true
        }
    }
}
