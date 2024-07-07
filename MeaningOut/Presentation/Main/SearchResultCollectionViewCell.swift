//
//  SearchResultTableViewCell.swift
//  MeaningOut
//
//  Created by 강석호 on 6/16/24.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    let mallLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let imageView = UIImageView()
    let likeButton = UIButton()
    var item: SearchResult?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        mallLabel.font = .systemFont(ofSize: 13)
        mallLabel.textColor = Colors.gray
        
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        
        priceLabel.font = .boldSystemFont(ofSize: 17)
        priceLabel.textColor = .black
        
        likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
        likeButton.setImage(UIImage(named: "like_selected"), for: .selected)
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        
        contentView.addSubview(imageView)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(contentView)
            make.height.equalTo(150)
        }
        
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(10)
            make.width.height.equalTo(40)
        }
    }
    
    func configure(with item: SearchResult) {
        self.item = item
        titleLabel.text = item.title
        priceLabel.text = "\(item.lprice) 원"
        mallLabel.text = item.mallName
        if let url = URL(string: item.image) {
            imageView.kf.setImage(with: url)
        }
        
        let isLiked = UserDefaults.standard.bool(forKey: "\(item.title)_liked")
        likeButton.isSelected = isLiked
    }
    
    @objc func toggleLike() {
        guard let item = item else { return }
        
        likeButton.isSelected.toggle()
        
        var selectedCount = UserDefaults.standard.integer(forKey: "selectedCount")
        if likeButton.isSelected {
            selectedCount += 1
            UserDefaults.standard.set(true, forKey: "\(item.title)_liked")
        } else {
            selectedCount -= 1
            UserDefaults.standard.set(false, forKey: "\(item.title)_liked")
        }
        
        UserDefaults.standard.set(selectedCount, forKey: "selectedCount")
        
        let realm = try! Realm()
        
        if likeButton.isSelected {
            let itemTable = ItemTable(title: item.title, price: item.lprice, imageUrl: item.image, mallName: item.mallName)
            try! realm.write {
                realm.add(itemTable)
            }
        } else {
            if let itemToDelete = realm.objects(ItemTable.self).filter("title == %@", item.title).first {
                try! realm.write {
                    realm.delete(itemToDelete)
                }
            }
        }
    }
}
