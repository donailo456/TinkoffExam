//
//  NewsViewController.swift
//  TinkoffExam
//
//  Created by Danil Komarov on 16.02.2023.
//

import UIKit
import WebKit

private var newsTitleLable1: UILabel = {
   let label = UILabel()
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 17, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()
private let subtitleLabel1: UILabel = {
   let label = UILabel()
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 16, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

private let newsImageView1: UIImageView = {
   let imageView = UIImageView()
    imageView.backgroundColor = .secondarySystemBackground
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
}()

private let newsButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemBlue
    button.setTitle("Дополнительная информация", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

var urlWK = ""

class NewsViewController: UIViewController {
    
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createNewsVC()
        constraint()
        view.backgroundColor = .systemGray
        
    }
    func createNewsVC(){
        view.addSubview(newsTitleLable1)
        view.addSubview(subtitleLabel1)
        view.addSubview(newsImageView1)
        view.addSubview(newsButton)
        newsButton.addTarget(self, action: #selector(createWK), for: .touchUpInside)
    }
    func constraint(){
        NSLayoutConstraint.activate([
            newsTitleLable1.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            newsTitleLable1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newsTitleLable1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel1.topAnchor.constraint(equalTo: newsTitleLable1.bottomAnchor, constant: 15),
            subtitleLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleLabel1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            newsImageView1.topAnchor.constraint(equalTo: subtitleLabel1.bottomAnchor, constant: 15),
            newsImageView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newsImageView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newsImageView1.heightAnchor.constraint(equalToConstant: 150),
            newsImageView1.widthAnchor.constraint(equalToConstant: 150),
            
            newsButton.topAnchor.constraint(equalTo: newsImageView1.bottomAnchor, constant: 20),
            newsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    @objc func createWK(){
        present(WebViewController(), animated: true)
        
    }
    
}

func addViewNews(with viewModel: NewsTableViewCellViewModel ){
    
    newsTitleLable1.text = viewModel.title
    subtitleLabel1.text = viewModel.subtitle
    urlWK = viewModel.url ?? ""
    
    if let data = viewModel.imageData{
        newsImageView1.image = UIImage(data: data)
    }
    else if let url = viewModel.urlToImage {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            viewModel.imageData = data
            DispatchQueue.main.async {
                newsImageView1.image = UIImage(data: data)
            }
        }.resume()
    }
}
