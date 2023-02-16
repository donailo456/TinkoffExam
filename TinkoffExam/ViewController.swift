//
//  ViewController.swift
//  TinkoffExam
//
//  Created by Danil Komarov on 16.02.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var myTableView = UITableView()
    var myView = NewsViewController()

    var selectedIndexPath: IndexPath = IndexPath()
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
//    var cachedDataSource: NSCache<AnyObject, UIImage>

    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        

    }
    
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()
    
    func createTable() {
        self.myTableView = UITableView(frame: view.bounds, style: .plain)
        myTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        myTableView.refreshControl = myRefreshControl
        view.addSubview(myTableView)
        
        APICaller.shared.getTopStories{ [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "", urlToImage: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.myTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
        APICaller.shared.getTopStories{ [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "", urlToImage: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.myTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTableView.frame = view.bounds
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        
        
        
        return cell
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        present(NewsViewController(), animated: true)
        addViewNews(with: viewModels[indexPath.row])
        
    }
    
}


