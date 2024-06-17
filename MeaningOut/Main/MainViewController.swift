//
//  MainViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/15/24.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let searchTableView = UITableView()
    let noSearchImageView = UIImageView()
    let noSearchLabel = UILabel()
    let headerView = UIView()
    let headerLabel = UILabel()
    let clearAllButton = UIButton()
    
    var recentSearches: [Entity] = []
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
        fetchRecentSearches()
    }
    
    func configureNavigation() {
        let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
        navigationItem.title = "\(nickname)'s Meaning Out"
    }
    
    func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(searchTableView)
        view.addSubview(noSearchLabel)
        view.addSubview(noSearchImageView)
        
        headerView.addSubview(headerLabel)
        headerView.addSubview(clearAllButton)
        
        searchTableView.tableHeaderView = headerView
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        searchBar.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        noSearchImageView.image = UIImage(named: "empty")
        noSearchImageView.contentMode = .scaleAspectFit
        noSearchImageView.clipsToBounds = true
        
        noSearchLabel.text = StringLiterals.LabelText.nosearchTitle
        noSearchLabel.textAlignment = .center
        noSearchLabel.font = .boldSystemFont(ofSize: 17)
        noSearchLabel.isHidden = true
        
        headerLabel.text = StringLiterals.LabelText.recentSearchTitle
        headerLabel.textAlignment = .right
        headerLabel.font = .boldSystemFont(ofSize: 18)
        
        clearAllButton.setTitle(StringLiterals.ButtonTitle.allDelete, for: .normal)
        clearAllButton.setTitleColor(Colors.orange, for: .normal)
        clearAllButton.addTarget(self, action: #selector(clearAllSearches), for: .touchUpInside)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noSearchImageView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(200)
        }
        
        noSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(noSearchImageView.snp.bottom).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.frame = CGRect(x: 0, y: 0, width: searchTableView.frame.width, height: 44)
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerView.snp.leading).inset(16)
            make.centerY.equalTo(headerView.snp.centerY)
        }
        clearAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(headerView.snp.trailing).inset(16)
            make.centerY.equalTo(headerView.snp.centerY)
        }
    }
    
    func fetchRecentSearches() {
        guard let context = context else { return }
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            recentSearches = try context.fetch(fetchRequest)
            updateUI()
        } catch {
            print("Failed to fetch recent searches: \(error)")
        }
    }
    
    func delete<T: NSManagedObject>(at index: Int, request: NSFetchRequest<T>) -> Bool {
        request.predicate = NSPredicate(format: "index = %@", NSNumber(value: index))
        
        do {
            if let recentTerms = try context?.fetch(request) {
                if recentTerms.count == 0 { return false }
                context?.delete(recentTerms[0])
                try context?.save()
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        do {
            if let recentTerms = try context?.fetch(request) {
                for term in recentTerms {
                    context?.delete(term)
                }
                try context?.save()
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    func saveRecentSearch(term: String, date: Date, index: Int32, completion: @escaping (Bool) -> Void) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        else { return }
        
        guard let recentTerms = NSManagedObject(entity: entity, insertInto: context) as? Entity else { return }
        
        recentTerms.term = term
        recentTerms.date = date
        recentTerms.index = index
        
        do {
            try context.save()
            fetchRecentSearches() // 저장 후 데이터 갱신
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func updateUI() {
        if recentSearches.isEmpty {
            searchTableView.isHidden = true
            noSearchLabel.isHidden = false
            noSearchImageView.isHidden = false
        } else {
            searchTableView.isHidden = false
            noSearchLabel.isHidden = true
            noSearchImageView.isHidden = true
            searchTableView.reloadData()
        }
    }
    
    @objc func clearAllSearches() {
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        if deleteAll(request: fetchRequest) {
            recentSearches.removeAll()
            updateUI()
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        let currentDate = Date()
        let currentIndex = Int32(recentSearches.count)
        
        saveRecentSearch(term: searchTerm, date: currentDate, index: currentIndex) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.updateUI()
                    let searchResultsVC = SearchResultViewController()
                    searchResultsVC.searchTerm = searchTerm
                    self?.navigationController?.pushViewController(searchResultsVC, animated: true)
                }
            } else {
                print("Error")
            }
        }
        searchBar.resignFirstResponder()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = recentSearches[indexPath.row].term

        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        deleteButton.tintColor = .black
        deleteButton.tag = indexPath.row
        deleteButton.addTarget(self, action: #selector(deleteRecentSearch(_:)), for: .touchUpInside)
        cell.accessoryView = deleteButton
        
        return cell
    }
    
    @objc func deleteRecentSearch(_ sender: UIButton) {
        let index = sender.tag
        let searchTermToDelete = recentSearches[index]
        
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        if delete(at: Int(searchTermToDelete.index), request: fetchRequest) {
            recentSearches.remove(at: index)
            updateUI()
        }
    }
}
