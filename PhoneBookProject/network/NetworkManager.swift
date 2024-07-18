//
//  NetworkManager.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/18/24.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
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
    
    func imageSetting(url: String, imageView: UIImageView) {
        guard let imageUrl = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            // 에러 처리
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }
            
            // 데이터 확인
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load image: Data is nil")
                return
            }
            
            // 메인 스레드에서 UI 업데이트
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
}
