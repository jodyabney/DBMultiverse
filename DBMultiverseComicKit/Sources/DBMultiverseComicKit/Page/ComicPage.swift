//
//  ComicPage.swift
//
//
//  Created by Nikolai Nobadi on 1/7/25.
//

import SwiftUI

public struct ComicPage {
    public let chapterName: String
    public let pagePosition: PagePosition
    public let image: UIImage
    
    public init(chapterName: String, pagePosition: PagePosition, image: UIImage) {
        self.chapterName = chapterName
        self.pagePosition = pagePosition
        self.image = image
    }
}


// MARK: - Dependencies
public struct PagePosition {
    public let page: Int
    public let totalPages: Int
    
    public init(page: Int, totalPages: Int) {
        self.page = page
        self.totalPages = totalPages
    }
}
