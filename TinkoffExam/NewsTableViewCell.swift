//
//  NewsTableViewCell.swift
//  TinkoffExam
//
//  Created by Danil Komarov on 16.02.2023.
//

import UIKit

class NewsTableViewCellViewModel{
    let title: String
    let subtitle: String
    let urlToImage: URL?
    var imageData: Data?
    
    init(title: String, subtitle: String, urlToImage: URL?, imageData: Data? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.urlToImage = urlToImage
        self.imageData = imageData
    }

}

var dict = NSDictionary()

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLable: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    private let subtitleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLable)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLable.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 170, height: 70)
        subtitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 170, height: contentView.frame.size.height/2)
        newsImageView.frame = CGRect(x: contentView.frame.size.width-150, y: 15, width: 160, height: contentView.frame.size.height - 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLable.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel ){
        
        newsTitleLable.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        
        if let data = viewModel.imageData{
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.urlToImage {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
    }

}
