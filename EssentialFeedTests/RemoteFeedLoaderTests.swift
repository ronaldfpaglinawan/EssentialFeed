//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ronald Fornis Paglinawan on 10/06/2024.
//

import XCTest
import EssentialFeed

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    var requestedURLs = [URL]()
    
    func get(from url: URL) {
        requestedURL = url
        requestedURLs.append(url)
    }
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
    
    func test_loadTwice_requestsDataFromURLTwice() {
        // Arrange
        let url = URL(string: "http://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = makeSUT(url: url, client: client)
        
        // Act
        sut.load()
        
        // Assert
        XCTAssertEqual(client.requestedURLs, [url])
        XCTAssertEqual(client.requestedURL, url)
    }
    
    private func makeSUT(url: URL =  URL(string: "http://a-url.com")!, client:HTTPClient) -> RemoteFeedLoader {
        return RemoteFeedLoader(url: url, client: client)
    }
}
