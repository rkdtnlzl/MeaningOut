//
//  MyLikedCell.swift
//  MeaningOut
//
//  Created by 강석호 on 6/18/24.
//

import UIKit
import SnapKit

class MyLikedCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let likedImageView = UIImageView()
    let likedCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(likedImageView)
        contentView.addSubview(likedCountLabel)
        
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.text = "나의 장바구니 목록"
        titleLabel.textColor = .black
        
        likedImageView.contentMode = .scaleAspectFit
        likedImageView.clipsToBounds = true
        likedImageView.image = UIImage(named: "like_selected")

        likedCountLabel.font = .boldSystemFont(ofSize: 15)
        likedCountLabel.textColor = .black
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        likedCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        likedImageView.snp.makeConstraints { make in
            make.trailing.equalTo(likedCountLabel.snp.leading).inset(-5)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }
    }
    
    func configure() {
        let count = UserDefaults.standard.integer(forKey: "selectedCount")
        likedCountLabel.text = "\(count)개의 상품"
    }
}
