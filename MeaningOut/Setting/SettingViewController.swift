//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/17/24.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
    
    let tableView = UITableView()
    
    let list = ["나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureUI()
        configureTableView()
    }
    
    func configureNavigation() {
        navigationItem.title = StringLiterals.NavigationTitle.Setting
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        if indexPath.row == 0 {
            let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
            cell.textLabel?.text = "\(nickname)"
            cell.textLabel?.font = .boldSystemFont(ofSize: 17)
            cell.detailTextLabel?.text = "2024.06.15 가입"
            cell.detailTextLabel?.textColor = .gray
            cell.detailTextLabel?.font = .systemFont(ofSize: 14)
            
            let profileNumber = UserDefaults.standard.integer(forKey: "profileNumber")
            cell.imageView?.image = UIImage(named: "profile_\(profileNumber)")
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
            cell.imageView?.layer.borderWidth = 5
            cell.imageView?.layer.borderColor = UIColor.orange.cgColor
            cell.imageView?.layer.cornerRadius = 33
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.text = list[indexPath.row - 1]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        } else {
            return UITableView.automaticDimension
        }
    }
}
