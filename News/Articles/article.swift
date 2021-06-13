//
//  article.swift
//  News
//
//  Created by Bexultan Tokan on 13.06.2021.
//

import Foundation

class article {
    let title: String
    let subtitle: String
    let imgUrl: String
    let url: String
    
    init(title: String, subtitle: String, imgUrl: String, url: String) {
        self.title = title
        self.subtitle = subtitle
        self.imgUrl = imgUrl
        self.url = url
    }
}
