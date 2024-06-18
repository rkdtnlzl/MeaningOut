//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/17/24.
//

import UIKit
import SnapKit

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
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
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
        return list.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            let nickname = UserDefaults.standard.string(forKey: "\(UserDefaultsKey.nicknameKey)") ?? ""
            let profileNumber = UserDefaults.standard.integer(forKey: "\(UserDefaultsKey.profileNumberKey)")
            let profileImage = UIImage(named: "profile_\(profileNumber)")
            cell.configure(nickname: nickname, joinDate: "2024.06.15 가입", profileImage: profileImage)
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = list[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return UITableView.automaticDimension
        }
    }
}
