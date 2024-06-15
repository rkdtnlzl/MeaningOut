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
    let noSearchLabel = UILabel()
    
    var recentSearches: [Entity] = []
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
        setTarget()
        fetchRecentSearches()
    }
    
    func configureNavigation() {
        let nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Guest"
        navigationItem.title = "\(nickname)'s Meaning Out"
    }
    
    func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(searchTableView)
        view.addSubview(noSearchLabel)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        searchBar.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        noSearchLabel.text = "최근 검색어가 없어요"
        noSearchLabel.textAlignment = .center
        noSearchLabel.isHidden = true
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
        
        noSearchLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setTarget() {}
    
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
            recentSearches.append(recentTerms)
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
        } else {
            searchTableView.isHidden = false
            noSearchLabel.isHidden = true
            searchTableView.reloadData()
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
        return cell
    }
}
