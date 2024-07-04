//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Ronald Fornis Paglinawan on 10/06/2024.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
