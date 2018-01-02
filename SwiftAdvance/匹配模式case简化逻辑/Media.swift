//
//  Media.swift
//  SwiftAdvance
//
//  Created by ray on 2017/8/17.
//  Copyright © 2017年 ray. All rights reserved.
//

import Foundation

enum Media {
    case book(title: String, author: String, year: Int)
    case movie(title: String, director: String, year: Int)
    case webSite(urlString: String)
}

extension Media {
    var title: String? {
        switch self {
        case let .book(title, _, _): return title
        case let .movie(title, _, _): return title
        default: return nil
        }
    }
    var kind: String {
        /* Remember part 1 where we said we can omit the `(…)`
         associated values in the `case` if we don't care about any of them? */
        switch self {
        case .book: return "Book"
        case .movie: return "Movie"
        case .webSite: return "Web Site"
        }
    }
}

enum NetworkResponse {
    case response(response: URLResponse,data: NSData)
    case error(error: NSError)
}
