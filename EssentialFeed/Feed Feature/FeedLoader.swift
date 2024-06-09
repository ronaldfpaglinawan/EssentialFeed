//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Ronald Fornis Paglinawan on 10/06/2024.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
