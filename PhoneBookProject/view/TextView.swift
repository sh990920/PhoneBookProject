//
//  TextView.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/18/24.
//

import UIKit
import SnapKit

class TextView: UIView {
    let nameView = UITextView()
    let phoneNumberView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        textViewSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(nameView)
        addSubview(phoneNumberView)
        
        nameView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(35)
        }
        
        phoneNumberView.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(35)
        }
    }
    
    func textViewSetting() {
        nameView.font = .systemFont(ofSize: 20)
        nameView.textAlignment = .left
        nameView.isEditable = true
        nameView.isScrollEnabled = true
        nameView.dataDetectorTypes = [.link, .all]
        nameView.layer.borderWidth = 1.0
        nameView.layer.borderColor = UIColor.black.cgColor
        nameView.layer.cornerRadius = 8.0
        nameView.clipsToBounds = true
        
        phoneNumberView.font = .systemFont(ofSize: 20)
        phoneNumberView.textAlignment = .left
        phoneNumberView.isEditable = true
        phoneNumberView.isScrollEnabled = true
        phoneNumberView.dataDetectorTypes = [.link, .phoneNumber]
        phoneNumberView.layer.borderWidth = 1.0
        phoneNumberView.layer.borderColor = UIColor.black.cgColor
        phoneNumberView.layer.cornerRadius = 8.0
        phoneNumberView.clipsToBounds = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 특정 텍스트를 입력하지 못하게 하려면 false 반환
        return true
    }
}
