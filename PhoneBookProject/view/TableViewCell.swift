//
//  TableViewCell.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/15/24.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    let networkManager = NetworkManager.shared
    
    let poketMonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: PhoneBook) {
        guard let name = item.name, let phoneNumber = item.phoneNumber, let image = item.image else { return }
        nameLabel.text = name
        phoneNumberLabel.text = phoneNumber
        networkManager.imageSetting(url: image, imageView: poketMonImageView)
    }
    
    func configureUI() {
        poketMonImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        poketMonImageView.layer.cornerRadius = 25
        poketMonImageView.layer.borderWidth = 2
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(70)
        }
        
        let stackView = UIStackView(arrangedSubviews: [poketMonImageView, nameLabel, phoneNumberLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
