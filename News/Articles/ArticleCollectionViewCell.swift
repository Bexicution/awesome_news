//
//  ArticleCollectionViewCell.swift
//  News
//
//  Created by Bexultan Tokan on 12.06.2021.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var articleView: UIView!
    @IBOutlet var subtitle: UILabel!
    
   
    @IBOutlet var title: UILabel!
    @IBOutlet var photoCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        articleView.layer.cornerRadius = 16
        articleView.layer.masksToBounds = true
        
        photoCell.layer.cornerRadius = 16
        photoCell.layer.masksToBounds = true
        
        
    }
    
    func configure(with article: article) {
        title.text = article.title
        subtitle.text = article.subtitle
        photoCell.load(url: URL(string: article.imgUrl) ?? URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/480px-No_image_available.svg.png")!)
        
//        DispatchQueue.global().async { [weak self] in
//                   if let data = try? Data(contentsOf: url) {
//                       if let image = UIImage(data: data) {
//                           DispatchQueue.main.async {
//                               self?.image = image
//                           }
//                       }
//                   }
//               }
    }
}
