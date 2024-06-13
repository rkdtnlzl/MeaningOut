//
//  ViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/13/24.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {

    let onboardingTitleLabel = UILabel()
    let onboardingTitleImageView = UIImageView()
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        setTarget()
    }
    
    func configureHierarchy() {
        view.addSubview(onboardingTitleLabel)
        view.addSubview(onboardingTitleImageView)
        view.addSubview(startButton)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        onboardingTitleLabel.text = StringLiterals.LabelText.onboardingTitle
        onboardingTitleLabel.font = .systemFont(ofSize: 40, weight: .black)
        onboardingTitleLabel.textColor = Colors.orange
        
        onboardingTitleImageView.image = UIImage(named: "launch")
        onboardingTitleImageView.contentMode = .scaleAspectFill
        onboardingTitleImageView.clipsToBounds = true
        
        startButton.tintColor = .white
        startButton.backgroundColor = Colors.orange
        startButton.setTitle(StringLiterals.ButtonTitle.launch, for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 20
    }
    
    func configureLayout() {
        onboardingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        onboardingTitleImageView.snp.makeConstraints { make in
            make.top.equalTo(onboardingTitleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(300)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }

    func setTarget() {
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    @objc func startButtonClicked() {
        let vc = ProfileSettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

