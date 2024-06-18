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
    var totalResults: Int = 0
    var currentPage = 1
    var isFetching = false
    var isEnd = false
    let resultsCountLabel = UILabel()
    let sortStackView = UIStackView()
    let sortAccuracyButton = UIButton()
    let sortDateButton = UIButton()
    let sortPriceHighButton = UIButton()
    let sortPriceLowButton = UIButton()
    
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
        view.addSubview(resultsCountLabel)
        view.addSubview(sortStackView)
        view.addSubview(collectionView)
        
        sortStackView.addArrangedSubview(sortAccuracyButton)
        sortStackView.addArrangedSubview(sortDateButton)
        sortStackView.addArrangedSubview(sortPriceHighButton)
        sortStackView.addArrangedSubview(sortPriceLowButton)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        resultsCountLabel.textAlignment = .center
        resultsCountLabel.font = .boldSystemFont(ofSize: 16)
        resultsCountLabel.textColor = Colors.orange
        
        sortStackView.axis = .horizontal
        sortStackView.distribution = .fillEqually
        sortStackView.spacing = 6
        
        configureButton(sortAccuracyButton, title: StringLiterals.ButtonTitle.sortAccuracy)
        configureButton(sortDateButton, title: StringLiterals.ButtonTitle.sortDate)
        configureButton(sortPriceHighButton, title: StringLiterals.ButtonTitle.sortPriceHigh)
        configureButton(sortPriceLowButton, title: StringLiterals.ButtonTitle.sortPriceLow)
        
        sortAccuracyButton.addTarget(self, action: #selector(sortByAccuracy), for: .touchUpInside)
        sortDateButton.addTarget(self, action: #selector(sortByDate), for: .touchUpInside)
        sortPriceHighButton.addTarget(self, action: #selector(sortByPriceHigh), for: .touchUpInside)
        sortPriceLowButton.addTarget(self, action: #selector(sortByPriceLow), for: .touchUpInside)
    }
    
    func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func configureLayout() {
        resultsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        sortStackView.snp.makeConstraints { make in
            make.top.equalTo(resultsCountLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(36)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
    }
    
    func fetchSearchResults() {
        guard !isFetching && !isEnd else { return }
        isFetching = true
        
        let url = APIURL.naverSearchURI
        let parameters: [String: String] = [
            "query": searchTerm,
            "display": "10",
            "start": "\(currentPage)"
        ]
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "\(APIKey.naverID)",
            "X-Naver-Client-Secret": "\(APIKey.naverSecret)"
        ]
        
        AF.request(url, parameters: parameters, headers: headers).responseDecodable(of: SearchResponse.self) { response in
            self.isFetching = false
            switch response.result {
            case .success(let data):
                self.searchResults.append(contentsOf: data.items)
                self.isEnd = data.items.isEmpty
                self.totalResults = data.total
                self.resultsCountLabel.text = "총 \(self.totalResults)개의 결과"
                self.collectionView.reloadData()
            case .failure(let error):
                print("Error fetching search results: \(error)")
            }
        }
    }
    
    @objc func sortByAccuracy() {
        resetButtonColors()
        toggleButtonAppearance(button: sortAccuracyButton)
        self.currentPage = 1
        self.isFetching = false
        self.isEnd = false
        self.searchResults.removeAll()
        fetchSearchResults()
    }

    @objc func sortByDate() {
        resetButtonColors()
        toggleButtonAppearance(button: sortDateButton)
        self.currentPage = 1
        self.isFetching = false
        self.isEnd = false
        self.searchResults.removeAll()
        fetchSearchResults()
    }
    
    @objc func sortByPriceHigh() {
        resetButtonColors()
        toggleButtonAppearance(button: sortPriceHighButton)
        searchResults.sort { Int($0.lprice) ?? 0 > Int($1.lprice) ?? 0 }
        collectionView.reloadData()
    }
    
    @objc func sortByPriceLow() {
        resetButtonColors()
        toggleButtonAppearance(button: sortPriceLowButton)
        searchResults.sort { Int($0.lprice) ?? 0 < Int($1.lprice) ?? 0 }
        collectionView.reloadData()
    }
    
    func resetButtonColors() {
        let buttons = [sortAccuracyButton, sortDateButton, sortPriceHighButton, sortPriceLowButton]
        for button in buttons {
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
        }
    }
    
    func toggleButtonAppearance(button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searchResults[indexPath.item]
        let vc = SearchResultDetailViewController()
        vc.urlString = item.link
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            currentPage += 1
            fetchSearchResults()
        }
    }
}
