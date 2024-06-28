//
//  String+.swift
//  MeaningOut
//
//  Created by 강석호 on 6/28/24.
//

import UIKit

extension String {
    func validateNickname() -> NicknameValidationResult {
        let specialLiterals = CharacterSet(charactersIn: "@#$%")
        let numbers = CharacterSet.decimalDigits
        
        if self.count < 2 || self.count > 9 {
            return .invalidLength
        } else if self.rangeOfCharacter(from: specialLiterals) != nil {
            return .containsSpecialCharacters
        } else if self.rangeOfCharacter(from: numbers) != nil {
            return .containsNumbers
        } else {
            return .valid
        }
    }
}
