//
//  PoketMonImageView.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/16/24.
//

import UIKit

class DetailView: UIView {
    
    let imageView = UIImageView()
    let button = UIButton()
    let networkManager = NetworkManager.shared
    
    var imageURL = ""
    
    init() {
        super.init(frame: .zero)
        configure()
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(imageView)
        addSubview(button)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        button.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setting() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true
        
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(randomImage), for: .touchUpInside)
    }
    
    @objc
    private func randomImage() {
        print("이미지 랜덤 생성 버튼 클릭")
        
        let num = Int.random(in: 1...1000)
        let strUrl = "https://pokeapi.co/api/v2/pokemon/\(num)"
        
        guard let url = URL(string: strUrl) else { return }
        networkManager.fetchData(url: url) { [weak self] (result: PoketMon?) in
            guard let self = self, let result else { return }
            networkManager.imageSetting(url: result.sprites.frontDefault, imageView: imageView)
            imageURL = result.sprites.frontDefault
        }
    }
    
}
