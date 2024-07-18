//
//  DetailViewController.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/12/24.
//

import UIKit
import SnapKit
import Foundation
import CoreData

class PhoneBookViewController: UIViewController {
    
    var item: PhoneBook? = nil
    var currentName = ""
    let detailView = DetailView()
    let textView = TextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSetting()
    }
    
    func configureUI() {
        [
            detailView,
            textView
        ].forEach { view.addSubview($0) }
        
        detailView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.height.equalTo(250)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(detailView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureSetting() {
        view.backgroundColor = .white
        self.title = "연락처 추가"
        textView.nameView.text = "이름"
        textView.phoneNumberView.text = "전화번호"
        var applyButton = UIBarButtonItem()
        if let item = item {
            itemSetting(item: item)
            if let name = item.name, let imageUrl = item.image {
                currentName = name
                detailView.imageURL = imageUrl
            }
            applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(updateButtonTapped))
        } else {
            applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonTapped))
        }
        self.navigationItem.rightBarButtonItem = applyButton
    }
    
    func itemSetting(item: PhoneBook) {
        guard let name = item.name, let phoneNumber = item.phoneNumber, let image = item.image else { return }
        self.title = name
        textView.nameView.text = name
        textView.phoneNumberView.text = phoneNumber
        NetworkManager.shared.imageSetting(url: image, imageView: detailView.imageView)
    }
    
    @objc func applyButtonTapped() {
        print("적용 버튼이 눌렸습니다.")
        DataManager.shared.createData(image: detailView.imageURL, name: textView.nameView.text, phoneNumber: textView.phoneNumberView.text)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func updateButtonTapped() {
        DataManager.shared.updateData(currentName: currentName, updateName: textView.nameView.text, updatePhoneNumber: textView.phoneNumberView.text, updateImage: detailView.imageURL)
        self.navigationController?.popViewController(animated: true)
    }
        
}
