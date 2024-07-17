//
//  ViewController.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/12/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
//    let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.backgroundColor = .green
//        return tableView
//    }()
//    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "추가"
        button.style = .plain
        button.target = self
        button.action = #selector(addButtonTapped)
        return button
    }()
    
    let tableView = TableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.readAllData()
        tableView.viewController = self
    }
    
//    private func configureUI() {
//        view.backgroundColor = .white
//        
//    }

    private func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.title = "친구 목록"
        [
            tableView
        ].forEach { view.addSubview($0) }
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
    
    
    @objc
    private func addButtonTapped() {
        let phoneBookVC = PhoneBookViewController()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
}

