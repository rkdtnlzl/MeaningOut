//
//  MainViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/15/24.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
        setTarget()
    }
    
    func configureNavigation() {
        let nickname = UserDefaults.standard.string(forKey: "nickname")!
        navigationItem.title = "\(nickname)'s Meaning Out"
    }
    
    func configureHierarchy() {
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureLayout() {
        
    }

    func setTarget() {
        
    }
    
    @objc func startButtonClicked() {
        
    }
}
