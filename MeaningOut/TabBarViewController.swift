//
//  TabBarViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/17/24.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = Colors.orange
        tabBar.unselectedItemTintColor = .gray
        
        let search = MainViewController()
        let nav1 = UINavigationController(rootViewController: search)
        nav1.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let favofites = FavoritesViewController()
        let nav2 = UINavigationController(rootViewController: favofites)
        nav2.tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        let setting = SettingViewController()
        let nav3 = UINavigationController(rootViewController: setting)
        nav3.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 2)
        
        setViewControllers([nav1,nav2,nav3], animated: true)
    }
}
