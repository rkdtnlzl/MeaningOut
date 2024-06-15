//
//  StringLiterals.swift
//  MeaningOut
//
//  Created by 강석호 on 6/13/24.
//

import Foundation

enum StringLiterals {
    enum LabelText {
        static let onboardingTitle = "MeaningOut"
        
        enum NickNameStatus {
            static let rightCase = "사용할 수 있는 닉네임입니다"
            static let numberOfLiteralsCase = "2글자 이상 10글자 미만으로 설정해주세요"
            static let specialLiteralsCase = "닉네임에 @, #, $, %는 포함할 수 없어요"
            static let numberCase = "닉네임에 숫자는 포함할 수 없어요"
        }
    }
    
    enum ButtonTitle {
        static let launch = "시작하기"
        static let finish = "완료"
    }
    
    enum Placeholder {
        static let requestNickName = "닉네임을 입력해주세요 :)"
    }
    
    enum NavigationTitle {
        static let profileSetting = "PROFILE SETTING"
    }
}
