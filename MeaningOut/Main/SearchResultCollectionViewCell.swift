//
//  SearchResultTableViewCell.swift
//  MeaningOut
//
//  Created by 강석호 on 6/16/24.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    let mallLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let imageView = UIImageView()
    
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
        
        contentView.addSubview(imageView)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
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
    }
    
    func configure(with item: SearchResult) {
        titleLabel.text = item.title
        priceLabel.text = "\(item.lprice) 원"
        mallLabel.text = item.mallName
        if let url = URL(string: item.image) {
            imageView.kf.setImage(with: url)
        }
    }
}
