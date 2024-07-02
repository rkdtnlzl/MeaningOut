//
//  SearchResultDetailViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/17/24.
//

import UIKit
import WebKit
import SnapKit

final class SearchResultDetailViewController: BaseViewController {
    
    var urlString: String?
    private let webView = WKWebView()
    private var likedButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigation()
        loadURL()
    }
    
    func configureNavigation() {
        likedButton = UIBarButtonItem(image: UIImage(named: "like_unselected"), style: .plain, target: self, action: #selector(likedButtonClicked))
        
        navigationItem.rightBarButtonItem = likedButton
    }
    
    override func configureLayout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func loadURL() {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc func likedButtonClicked() {
        
    }
}
