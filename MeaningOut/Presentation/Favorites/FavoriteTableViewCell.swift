//
//  FavoriteTableViewCell.swift
//  MeaningOut
//
//  Created by 강석호 on 7/7/24.
//

import UIKit
import SnapKit
import Kingfisher

class FavoriteTableViewCell: BaseTableViewCell {
    
    let mallLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let itemImageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func configureView() {
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 10
        
        mallLabel.font = .systemFont(ofSize: 13)
        mallLabel.textColor = .gray
        
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        
        priceLabel.font = .boldSystemFont(ofSize: 17)
        priceLabel.textColor = .black
    }
    
    override func configureLayout() {
        itemImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(60)
        }
        
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalTo(itemImageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(mallLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(mallLabel)
            make.bottom.equalTo(contentView).inset(10)
        }
    }
    
    func configure(with item: ItemTable) {
        titleLabel.text = item.title
        priceLabel.text = "\(item.price) 원"
        mallLabel.text = item.mallName
        if let url = URL(string: item.imageUrl) {
            itemImageView.kf.setImage(with: url)
        }
    }
}
