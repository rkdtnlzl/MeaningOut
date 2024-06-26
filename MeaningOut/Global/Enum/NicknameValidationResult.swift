//
//  NicknameValidationResult.swift
//  MeaningOut
//
//  Created by 강석호 on 6/28/24.
//

import UIKit

enum NicknameValidationResult {
    case valid
    case invalidLength
    case containsSpecialCharacters
    case containsNumbers
    
    var message: String {
        switch self {
        case .valid:
            return StringLiterals.LabelText.NickNameStatus.rightCase
        case .invalidLength:
            return StringLiterals.LabelText.NickNameStatus.numberCase
        case .containsSpecialCharacters:
            return StringLiterals.LabelText.NickNameStatus.specialLiteralsCase
        case .containsNumbers:
            return StringLiterals.LabelText.NickNameStatus.numberOfLiteralsCase
        }
    }
    
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        default:
            return false
        }
    }
}
