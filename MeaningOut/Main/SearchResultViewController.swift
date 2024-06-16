//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/16/24.
//

import UIKit
import SnapKit
import Alamofire

//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/16/24.
//

import UIKit
import SnapKit
import Alamofire

class SearchResultViewController: UIViewController {
    
    var searchTerm: String = ""
    var searchResults: [SearchResult] = []
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        fetchSearchResults()
    }
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    func configureNavigation() {
        navigationItem.title = "\(searchTerm)"
    }
    
    func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        
        collectionView.isPagingEnabled = true
    }
    
    func fetchSearchResults() {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let parameters: [String: String] = [
            "query": searchTerm,
            "display": "10"
        ]
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "\(APIKey.naverID)",
            "X-Naver-Client-Secret": "\(APIKey.naverSecret)"
        ]
        
        AF.request(url, parameters: parameters, headers: headers).responseDecodable(of: SearchResponse.self) { response in
            switch response.result {
            case .success(let data):
                self.searchResults = data.items
                self.collectionView.reloadData()
            case .failure(let error):
                print("Error fetching search results: \(error)")
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as! SearchResultCollectionViewCell
        let item = searchResults[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width - 30
        let itemWidth = collectionViewSize / 2
        return CGSize(width: itemWidth, height: itemWidth + 80)
    }
}
