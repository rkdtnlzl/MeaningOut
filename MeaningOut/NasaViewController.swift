//
//  NasaViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 7/1/24.
//

import UIKit
import SnapKit

class NasaViewController: BaseViewController {
    
    let nasaImageView = UIImageView()
    let progressLabel = UILabel()
    let requestButton = UIButton()
    
    var total: Double = 0.0
    var buffer: Data? {
        didSet {
            let result = Double(buffer?.count ?? 0) / total
            progressLabel.text = "\(result * 100) / 100"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        requestButton.backgroundColor = .blue
        progressLabel.backgroundColor = .lightGray
        nasaImageView.backgroundColor = .systemBrown
        
        requestButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
    }
    
    override func configureLayout() {
        requestButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        progressLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(requestButton.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        nasaImageView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
        }
    }
    
    @objc func requestButtonClicked() {
        print(#function)
        
        buffer = Data()
        
        callRequest()
    }
    
    func callRequest() {
        let request = URLRequest(url: Nasa.photo)

        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: request).resume()
    }
}

extension NasaViewController: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        print(#function, response)
        
        if let response = response as? HTTPURLResponse,
           (200...299).contains(response.statusCode) {
            
            //총 데이터의 양 얻기
            let contentLength = response.value(forHTTPHeaderField: "Content-Length")!
            
            total = Double(contentLength)!
            
            return .allow
        } else {
            return .cancel
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(#function, data)
        
        buffer?.append(data)
        
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        
        if error != nil {
            progressLabel.text = "문제가 발생됨"
        } else {
            print("성공")
            
            guard let buffer = buffer else {
                print("Buffer nil")
                return
            }
            
            let image = UIImage(data: buffer)
            nasaImageView.image = image
        }
    }
}
