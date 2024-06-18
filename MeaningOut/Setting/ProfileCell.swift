//
//  ProfileCell.swift
//  MeaningOut
//
//  Created by 강석호 on 6/17/24.
//

import UIKit
import SnapKit

class ProfileCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let joinDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(joinDateLabel)
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.orange.cgColor
        profileImageView.layer.cornerRadius = 33
        nameLabel.font = .boldSystemFont(ofSize: 17)
        joinDateLabel.font = .systemFont(ofSize: 14)
        joinDateLabel.textColor = .gray
        
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(66)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.top.equalToSuperview().offset(20)
        }
        
        joinDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    func configure(nickname: String, joinDate: String, profileImage: UIImage?) {
        nameLabel.text = nickname
        joinDateLabel.text = joinDate
        profileImageView.image = profileImage
    }
}
