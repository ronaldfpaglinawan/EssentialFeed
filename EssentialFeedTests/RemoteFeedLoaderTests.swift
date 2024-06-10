//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ronald Fornis Paglinawan on 10/06/2024.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "http://a-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func get(from url: URL?) {}
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    
    override func get(from url: URL?) {
        requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let _ = RemoteFeedLoader()
        
        // Act
        
        // Assert
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        // Arrange
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        // Act
        sut.load()
        
        // Assert
        XCTAssertNotNil(client.requestedURL)
    }
}
