//
//  APICaller.swift
//  TinkoffExam
//
//  Created by Danil Komarov on 16.02.2023.
//

import UIKit
import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constatant{
        static let topHeadlinesURL = URL(string:"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=c30fb55b1ae644f490d55ce0efaddef8")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void){
        
        
        guard let url = Constatant.topHeadlinesURL else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}



struct APIResponse: Codable{
    let articles: [Article]
}
struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}
struct Source: Codable {
    let name: String
}
