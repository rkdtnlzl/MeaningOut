//
//  ProfileNicknameModifyViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/18/24.
//

import UIKit
import SnapKit

final class ProfileNicknameModifyViewController: BaseViewController {
    
    private let profileImageView = UIImageView()
    private let profileImageButton = UIButton()
    private let nicknameTextField = UITextField()
    private let nicknameTextFieldLine = UIView()
    private let nicknameStatusLabel = UILabel()
    private var saveButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileNumber = UserDefaults.standard.integer(forKey: "\(UserDefaultsKey.profileNumberKey)")
        profileImageView.image = UIImage(named: "profile_\(profileNumber)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        setTarget()
    }
    
    func configureNavigation() {
        navigationItem.title = StringLiterals.NavigationTitle.profileEdit
        saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageButton)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameTextFieldLine)
        view.addSubview(nicknameStatusLabel)
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        let profileNumber = UserDefaults.standard.integer(forKey: "\(UserDefaultsKey.profileNumberKey)")
        profileImageView.image = UIImage(named: "profile_\(profileNumber)")
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
    }
    
    override func configureLayout() {
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
    }
    
    func setTarget() {
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChange), for: .editingChanged)
        profileImageButton.addTarget(self, action: #selector(profileImageButtonClicked), for: .touchUpInside)
    }
    
    @objc func nicknameTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let specialLiterals = CharacterSet(charactersIn: "@#$%")
        let numbers = CharacterSet.decimalDigits
        if text.count < 2 || text.count > 9 {
            nicknameStatusLabel.text = StringLiterals.LabelText.NickNameStatus.numberCase
            saveButton.isEnabled = false
            saveButton.tintColor = .gray
        } else if text.rangeOfCharacter(from: specialLiterals) != nil {
            nicknameStatusLabel.text = StringLiterals.LabelText.NickNameStatus.specialLiteralsCase
            saveButton.isEnabled = false
            saveButton.tintColor = .gray
        } else if text.rangeOfCharacter(from: numbers) != nil {
            nicknameStatusLabel.text = StringLiterals.LabelText.NickNameStatus.numberOfLiteralsCase
            saveButton.isEnabled = false
            saveButton.tintColor = .gray
        } else {
            nicknameStatusLabel.text = StringLiterals.LabelText.NickNameStatus.rightCase
            saveButton.isEnabled = true
            saveButton.tintColor = Colors.orange
        }
    }
    
    @objc func profileImageButtonClicked() {
        let vc = ProfileImageModifyViewController()
        vc.selectedImage = profileImageView.image
        vc.navigationItem.hidesBackButton = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveButtonClicked() {
        UserDefaults.standard.set(nicknameTextField.text, forKey: "\(UserDefaultsKey.nicknameKey)")
        UserDefaults.standard.set(true, forKey: "\(UserDefaultsKey.isUserKey)")
        navigationController?.popViewController(animated: true)
    }
}
