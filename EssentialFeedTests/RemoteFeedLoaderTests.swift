//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ronald Fornis Paglinawan on 10/06/2024.
//

import XCTest
import EssentialFeed

class HTTPClientSpy: HTTPClient {
    func get(from url: URL) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        
        // Act
        
        // Assert
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        // Arrange
        let url = URL(string: "http://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = makeSUT(url: url, client: client)
        
        // Act
        sut.load()
        
        // Assert
        XCTAssertEqual(client.requestedURL, url)
    }
    
    private func makeSUT(url: URL =  URL(string: "http://a-url.com")!, client:HTTPClient) -> RemoteFeedLoader {
        return RemoteFeedLoader(url: url, client: client)
    }
}
