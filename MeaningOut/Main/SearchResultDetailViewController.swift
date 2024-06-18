//
//  SearchResultDetailViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/17/24.
//

import UIKit
import WebKit
import SnapKit

class SearchResultDetailViewController: UIViewController {
    
    var urlString: String?
    let webView = WKWebView()
    var likedButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureNavigation()
        loadURL()
    }
    
    func configureNavigation() {
        likedButton = UIBarButtonItem(image: UIImage(named: "like_unselected"), style: .plain, target: self, action: #selector(likedButtonClicked))
        
        navigationItem.rightBarButtonItem = likedButton
    }
    
    func configureLayout() {
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
