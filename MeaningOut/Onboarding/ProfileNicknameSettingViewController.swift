//
//  ProfileSettingViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileNicknameSettingViewController: UIViewController {
    
    let profileImageView = UIImageView()
    let profileImageButton = UIButton()
    let nicknameTextField = UITextField()
    let nicknameTextFieldLine = UIView()
    let nicknameStatusLabel = UILabel()
    let completeButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileNumber = UserDefaults.standard.integer(forKey: "profileNumber")
        profileImageView.image = UIImage(named: "profile_\(profileNumber)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
        setTarget()
    }
    
    func configureNavigation() {
        navigationItem.title = StringLiterals.NavigationTitle.profileSetting
    }
    
    func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageButton)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameTextFieldLine)
        view.addSubview(nicknameStatusLabel)
        view.addSubview(completeButton)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        profileImageView.image = UIImage(named: "profile_1")
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = Colors.orange.cgColor
        
        profileImageButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        profileImageButton.tintColor = .white
        profileImageButton.backgroundColor = Colors.orange
        profileImageButton.layer.cornerRadius = 16
        
        nicknameTextField.placeholder = StringLiterals.Placeholder.requestNickName
        nicknameTextField.tintColor = .lightGray
        
        nicknameTextFieldLine.backgroundColor = .darkGray
        
        nicknameStatusLabel.text = ""
        nicknameStatusLabel.textColor = Colors.orange
        nicknameStatusLabel.font = .systemFont(ofSize: 13)
        
        completeButton.tintColor = .white
        completeButton.backgroundColor = Colors.gray
        completeButton.setTitle(StringLiterals.ButtonTitle.finish, for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.layer.cornerRadius = 20
        completeButton.isEnabled = false
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImageView)
            make.width.height.equalTo(32)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view.safeAreaInsets).inset(20)
            make.height.equalTo(44)
        }
        
        nicknameTextFieldLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaInsets).inset(20)
            make.height.equalTo(1)
        }
        
        nicknameStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldLine.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaInsets).inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLabel.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view.safeAreaInsets).inset(20)
            make.height.equalTo(50)
        }
    }
    
    func setTarget() {
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChange), for: .editingChanged)
        profileImageButton.addTarget(self, action: #selector(profileImageButtonClicked), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    @objc func nicknameTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let specialLiterals = CharacterSet(charactersIn: "@#$%")
        let numbers = CharacterSet.decimalDigits
        
        if text.count < 2 || text.count > 9 {
            nicknameStatusLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            
        } else if text.rangeOfCharacter(from: specialLiterals) != nil {
            nicknameStatusLabel.text = "닉네임에 @ # $ % 는 포함할 수 없어요^^"
            completeButton.backgroundColor = Colors.gray
            completeButton.isEnabled = false
        } else if text.rangeOfCharacter(from: numbers) != nil {
            nicknameStatusLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            completeButton.backgroundColor = Colors.gray
            completeButton.isEnabled = false
        } else {
            nicknameStatusLabel.text = "사용할 수 있는 닉네임이에요"
            completeButton.backgroundColor = Colors.orange
            completeButton.isEnabled = true
        }
    }
    
    @objc func profileImageButtonClicked() {
        let vc = ProfileImageSettingViewController()
        vc.selectedImage = profileImageView.image
        vc.navigationItem.hidesBackButton = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func completeButtonClicked() {
        UserDefaults.standard.set(nicknameTextField.text, forKey: "nickname")
        UserDefaults.standard.set(true, forKey: "isUser")
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let rootVC = UINavigationController(rootViewController: TabBarController())
        sceneDelegate?.window?.rootViewController = rootVC
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
