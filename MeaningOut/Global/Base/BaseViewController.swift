//
//  BaseViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/25/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
}
