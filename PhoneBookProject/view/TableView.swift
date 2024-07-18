//
//  TableView.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/15/24.
//

import UIKit
import SnapKit
import CoreData

class TableView: UIView {
    
    var tableView = UITableView(frame: .zero, style: .plain)
    
    var items: [PhoneBook] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var container: NSPersistentContainer!
    
    var viewController: UIViewController?

    
    init() {
        super.init(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        configureUI()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        readAllData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func readAllData() {
        items.removeAll()
        do {
            let phoneBooks = try self.container.viewContext.fetch(PhoneBook.fetchRequest())

            for phoneBook in phoneBooks {
                items.append(phoneBook)
            }
            itemsSort()
        } catch {
            print("데이터 읽기 실패")
        }
    }
    
    func deleteData(name: String) {
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
            }
            
            try self.container.viewContext.save()
            
            print("데이터 삭제 성공")
            
        } catch {
            print("데이터 삭제 실패")
        }
        
    }
    
    func itemsSort() {
        for (i, _) in items.enumerated() {
            for (j, _) in items.enumerated() {
                if items[i].name! < items[j].name! {
                    let a = items[i]
                    items[i] = items[j]
                    items[j] = a
                }
            }
        }
    }
    
}


extension TableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let item = items[indexPath.row]
        cell.configure(with: item) // 셀 구성 함수 호출
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectItem = items[indexPath.item]
        let nextViewController = PhoneBookViewController()
        nextViewController.item = selectItem
        
        if let parentVC = viewController {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            parentVC.navigationItem.backBarButtonItem = backItem
            parentVC.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
}
