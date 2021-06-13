//
//  ViewController.swift
//  News
//
//  Created by Bexultan Tokan on 12.06.2021.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var Headline: UIView!
    @IBOutlet var Feed: UICollectionView!
    let articles = articlesStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let url = "https://newsapi.org/v2/everything?language=en&q=tesla&from=2021-05-13&sortBy=publishedAt&apiKey=1111ec90c31345c185787ece4e75f473"
        getData(from: url)
        
    }
    
    

    private func getData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("error occured")
                return
            }
        
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                print("failed to convert \(error.localizedDescription)")
            }
            guard let json = result else {
                return
            }
            for i in json.articles {
                let box = article(title: i.title ?? "null", subtitle: i.description ?? "null", imgUrl: i.urlToImage ?? "", url: i.url ?? "")
                self.articles.storage.append(box)
            }
            
            print(json.totalResults)
            print(self.articles.storage.count)
            
            DispatchQueue.main.async {
                self.Feed.reloadData()
            }
        }).resume()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.storage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "article_cell", for: indexPath) as! ArticleCollectionViewCell
        
        let storage = articles.storage[indexPath.row]
        cell.configure(with: storage)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath as IndexPath, animated: true)
        let article = articles.storage[indexPath.item]
        
        guard let url = URL(string: article.url) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndex = collectionView.numberOfItems(inSection: 0)
        if lastIndex - 10 == indexPath.row {
            print(lastIndex/20+1)
            let url = "https://newsapi.org/v2/everything?language=en&page=\(lastIndex/19+1)&q=tesla&from=2021-05-13&sortBy=publishedAt&apiKey=1111ec90c31345c185787ece4e75f473"
                getData(from: url)
        }
        
    }
  
    
    
    struct Response: Codable {
        let status: String
        let totalResults: Int
        let articles: [MyResult]
    }
    
    struct Source: Codable {
        let name: String
    }
    
    struct MyResult: Codable {
        let source: Source
        let author: String?
        let title: String?
        let description: String?
        let url: String?
        let urlToImage: String?
        let publishedAt: String
        //let content: String
    }
    
    /*
     
     status
     totalResults
     articles{
     "source":{"id":null,"name":"Wnd.com"},
     "author":"WND News Services",
     "title":"Is inflation 'doom' looming because of trillions 'sloshing' around'?",
     "description":"Does inflation doom loom? After all, the Fed’s humongous monetary “stimulus” exploded the money supply. Then, too, Uncle Sam drunken-sailored nearly $3 trillion in 2020 COVID “relief”--another $1.9 trillion this year—and up to $4 trillion more under discussio…",
     "url":"https://www.wnd.com/2021/06/inflation-doom-looming-trillions-sloshing-around/",
     "urlToImage":"https://www.wnd.com/wp-content/uploads/2021/02/burn-fire-money-cash-bill-Pixabay-copyright-free-image.jpg",
     "publishedAt":"2021-06-12T20:18:03Z",
     "content":"[Editor's note: This story originally was published by Real Clear Markets.]\r\nBy Ken FisherReal Clear Markets\r\nDoes inflation doom loom? After all, the Feds humongous monetary stimulus exploded the mo… [+6210 chars]"}
     
     */
}

extension UIImageView {
    func load(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
