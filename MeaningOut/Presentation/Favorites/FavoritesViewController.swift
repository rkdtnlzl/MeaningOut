//
//  FavoritesViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 7/7/24.
//

import UIKit
import SnapKit
import RealmSwift

final class FavoritesViewController: BaseViewController {
    
    private let tableView = UITableView()
    private var favoriteItems: Results<ItemTable>!
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
        tableView.reloadData()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "FavoriteTableViewCell")
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func fetchFavorites() {
        let realm = try! Realm()
        favoriteItems = realm.objects(ItemTable.self)
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        let item = favoriteItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}
