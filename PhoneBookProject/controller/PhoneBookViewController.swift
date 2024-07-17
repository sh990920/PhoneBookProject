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
    
    var container: NSPersistentContainer!
    
    var imageURL = ""
    
    var item: PhoneBook? = nil
    
    var currentName = ""
    
    let detailView = DetailView()
    
//    let imageChangeButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("랜덤 이미지 생성", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 15)
//        button.setTitleColor(.black, for: .normal)
//        return button
//    }()
    
    lazy var nameView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
        textView.textAlignment = .left
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.dataDetectorTypes = [.link, .phoneNumber]
        textView.delegate = self
        // 테두리 두께 설정
        textView.layer.borderWidth = 1.0
        
        // 테두리 색상 설정 (UIColor를 사용하여 색상을 지정)
        textView.layer.borderColor = UIColor.black.cgColor
        
        // 모서리 둥글게 설정 (선택 사항)
        textView.layer.cornerRadius = 8.0
        
        // 테두리를 반영하기 위해 클립을 설정 (선택 사항)
        textView.clipsToBounds = true
        return textView
    }()
    
    lazy var phoneNumberView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
        textView.textAlignment = .left
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.dataDetectorTypes = [.link, .phoneNumber]
        textView.delegate = self
        // 테두리 두께 설정
        textView.layer.borderWidth = 1.0
        // 테두리 색상 설정 (UIColor를 사용하여 색상을 지정)
        textView.layer.borderColor = UIColor.black.cgColor
        // 모서리 둥글게 설정 (선택 사항)
        textView.layer.cornerRadius = 8.0
        // 테두리를 반영하기 위해 클립을 설정 (선택 사항)
        textView.clipsToBounds = true
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "연락처 추가"
        view.backgroundColor = .white
        
        [
            detailView,
            nameView,
            phoneNumberView
        ].forEach { view.addSubview($0) }
        
        detailView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.height.equalTo(250)
        }
        
        nameView.snp.makeConstraints {
            $0.top.equalTo(detailView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(35)
        }
        
        phoneNumberView.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(35)
        }
        
        nameView.text = "이름"
        phoneNumberView.text = "전화번호"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        var applyButton = UIBarButtonItem()
        
        if let item = item {
            itemSetting(item: item)
            currentName = item.name!
            // 적용 버튼 설정
            applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(updateButtonTapped))
        } else {
            // 적용 버튼 설정
            applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonTapped))
        }
        self.navigationItem.rightBarButtonItem = applyButton
    }
    
    func itemSetting(item: PhoneBook) {
        guard let name = item.name, let phoneNumber = item.phoneNumber, let image = item.image else { return }
        self.title = name
        nameView.text = name
        phoneNumberView.text = phoneNumber
        detailView.imageSetting(url: image)
    }
    
    func readAllData() {
        do {
            let phoneBooks = try self.container.viewContext.fetch(PhoneBook.fetchRequest())
            
            for phoneBook in phoneBooks as [NSManagedObject] {
                if let name = phoneBook.value(forKey: PhoneBook.Key.name) as? String,
                   let phoneNumber = phoneBook.value(forKey: PhoneBook.Key.phoneNumber) as? String {
                    print("name : \(name), phoneNumber : \(phoneNumber)")
                }
            }
            
        } catch {
            print("데이터 읽기 실패")
        }
    }
    
    @objc func applyButtonTapped() {
        // 데이터 적용 동작
        print("적용 버튼이 눌렸습니다.")
        // 여기에서 데이터 추가 로직을 구현하세요.
        createData(image: detailView.imageURL, name: nameView.text, phoneNumber: phoneNumberView.text)
        readAllData()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func updateButtonTapped() {
        updateData(currentName: currentName, updateName: nameView.text, updatePhoneNumber: phoneNumberView.text, updateImage: detailView.imageURL)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func createData(image: String, name: String, phoneNumber: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: PhoneBook.className, in: self.container.viewContext) else { return }
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newPhoneBook.setValue(image, forKey: PhoneBook.Key.image)
        newPhoneBook.setValue(name, forKey: PhoneBook.Key.name)
        newPhoneBook.setValue(phoneNumber, forKey: PhoneBook.Key.phoneNumber)
        do {
            try self.container.viewContext.save()
            print("문맥 저장 성공")
        } catch {
            print("문맥 저장 실패")
        }
    }
    
    // CoreDataProject 에서 데이더 Update
    func updateData(currentName: String, updateName: String, updatePhoneNumber: String, updateImage: String) {
        
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", currentName)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                // data 중 name 의 값을 updateName 으로 update 한다
                data.setValue(updateName, forKey: PhoneBook.Key.name)
                data.setValue(updatePhoneNumber, forKey: PhoneBook.Key.phoneNumber)
                data.setValue(updateImage, forKey: PhoneBook.Key.image)
            }
            
            try self.container.viewContext.save()
            
            print("데이터 수정 성공")
        } catch {
            print("데이터 수정  실패")
        }
        
    }
    
}


extension PhoneBookViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        print("텍스트 뷰 편집 시작")
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        print("텍스트 뷰 편집 종료")
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        print("텍스트 변경: \(textView.text ?? "")")
//    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        // 특정 텍스트를 입력하지 못하게 하려면 false 반환
//        return true
//    }
}
