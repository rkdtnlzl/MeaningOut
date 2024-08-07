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

final class SettingViewController: BaseViewController {
    
    private let tableView = UITableView()
    
    private let list = ["나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func configureNavigation() {
        navigationItem.title = StringLiterals.NavigationTitle.Setting
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.register(MyLikedCell.self, forCellReuseIdentifier: "MyLikedCell")
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
            let joinDateLabel = UserDefaults.standard.string(forKey: UserDefaultsKey.joinDateKey) ?? ""
            cell.configure(nickname: nickname, joinDate: "\(joinDateLabel) 가입", profileImage: profileImage)
            cell.accessoryType = .disclosureIndicator
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLikedCell", for: indexPath) as! MyLikedCell
            cell.configure()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = list[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = ProfileNicknameModifyViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == list.count {
            showAlert(title: StringLiterals.AlertLabel.alertTitle,
                      message: StringLiterals.AlertLabel.alertMessage,
                      ok: "확인") { _ in
                if let appDomain = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                }
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let rootVC = UINavigationController(rootViewController: OnboardingViewController())
                sceneDelegate?.window?.rootViewController = rootVC
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return UITableView.automaticDimension
        }
    }
}
