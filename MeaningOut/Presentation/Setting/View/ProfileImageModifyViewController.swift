//
//  ProfileImageModifyViewController.swift
//  MeaningOut
//
//  Created by 강석호 on 6/18/24.
//

import UIKit
import SnapKit

final class ProfileImageModifyViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private let profileImageView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let imageNames = (0...11).map { "profile_\($0)" }
    private var selectedIndexPath: IndexPath?
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
        setTarget()
    }
    
    func configureNavigation() {
        navigationItem.title = StringLiterals.NavigationTitle.profileEdit
    }
    
    func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(collectionView)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = Colors.orange.cgColor
        profileImageView.clipsToBounds = true
        
        let profileNumber = UserDefaults.standard.integer(forKey: "\(UserDefaultsKey.profileNumberKey)")
        profileImageView.image = UIImage(named: "profile_\(profileNumber)")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func setTarget() {
    }
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 80, height: 80)
        return layout
    }
}

extension ProfileImageModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let imageView = UIImageView(image: UIImage(named: imageNames[indexPath.item]))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = cell.contentView.bounds
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)
        cell.layer.cornerRadius = 40
        cell.clipsToBounds = true
        if selectedIndexPath == indexPath {
            cell.layer.borderColor = UIColor.orange.cgColor
            cell.layer.borderWidth = 5
            cell.contentView.alpha = 1.0
        } else {
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 1
            cell.contentView.alpha = 0.5
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        profileImageView.image = UIImage(named: imageNames[indexPath.item])
        UserDefaults.standard.set(indexPath.item, forKey: "\(UserDefaultsKey.profileNumberKey)")
        collectionView.reloadData()
    }
}
