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
    
    var imageURL = ""
    
    init() {
        super.init(frame: .zero)
        configure()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(imageView)
        addSubview(button)
        imageView.snp.makeConstraints {
            //$0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
            //make.edges.equalToSuperview()
        }
        button.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            //make.edges.equalToSuperview()
        }
    }
    
    func imageSetting(url: String) {
        guard let imageUrl = URL(string: url) else { return }
        if let data = try? Data(contentsOf: imageUrl) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    @objc
    private func randomImage() {
        print("이미지 랜덤 생성 버튼 클릭")
        
        let num = Int.random(in: 1...1000)
        let strUrl = "https://pokeapi.co/api/v2/pokemon/\(num)"
        
        guard let url = URL(string: strUrl) else { return }
        fetchData(url: url) { [weak self] (result: PoketMon?) in
            guard let self = self, let result else { return }
            imageSetting(url: result.sprites.frontDefault)
            imageURL = result.sprites.frontDefault
        }
    }
    
    // 서버 데이터를 불러오는 메서드
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            // http status code 성공 범위.
            let successRange = 200..<300
             if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                completion(decodedData)
            } else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
    
}
