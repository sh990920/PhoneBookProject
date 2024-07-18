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
    let networkManager = NetworkManager.shared
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
        }
    }
    
    func configureSetting() {
        view.backgroundColor = .white
        self.title = "연락처 추가"
        textView.nameView.text = "이름"
        textView.phoneNumberView.text = "전화번호"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        var applyButton = UIBarButtonItem()
        
        if let item = item {
            itemSetting(item: item)
            currentName = item.name!
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
        networkManager.imageSetting(url: image, imageView: detailView.imageView)
    }
    
    @objc func applyButtonTapped() {
        print("적용 버튼이 눌렸습니다.")
        createData(image: detailView.imageURL, name: textView.nameView.text, phoneNumber: textView.phoneNumberView.text)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func updateButtonTapped() {
        updateData(currentName: currentName, updateName: textView.nameView.text, updatePhoneNumber: textView.phoneNumberView.text, updateImage: detailView.imageURL)
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
    
    func updateData(currentName: String, updateName: String, updatePhoneNumber: String, updateImage: String) {
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", currentName)
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            for data in result as [NSManagedObject] {
                data.setValue(updateName, forKey: PhoneBook.Key.name)
                data.setValue(updatePhoneNumber, forKey: PhoneBook.Key.phoneNumber)
                data.setValue(updateImage, forKey: PhoneBook.Key.image)
            }
            try self.container.viewContext.save()
            print("데이터 수정 성공")
        } catch {
            print("데이터 수정 실패")
        }
        
    }
    
}
