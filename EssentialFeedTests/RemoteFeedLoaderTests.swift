//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Ronald Fornis Paglinawan on 10/06/2024.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {

    // MARK: - Unit Tests
    func test_init_doesNotRequestDataFromURL() {
        // Arrange
        let (_, client) = makeSUT()
        
        // Act
        
        // Assert
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        // Arrange
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        // Act
        sut.load { _ in }
        
        // Assert
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        // Arrange
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        // Act
        sut.load { _ in }
        sut.load { _ in }
        
        // Assert
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        // Arrange
        let (sut, client) = makeSUT()
        
        // Act
        expect(sut, toCompleteWithError: .connectivity, when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        // Arrange
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        
        // Act
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithError: .invalidData, when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
        
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let (sut, client) = makeSUT()
        
        // Act
        expect(sut, toCompleteWithError: .invalidData, when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL =  URL(string: "http://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, 
                        toCompleteWithError error: RemoteFeedLoader.Error,
                        when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        action()
        
        // Assert
        XCTAssertEqual(capturedErrors, [error], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index], 
                statusCode:code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success(data, response))
        }
    }
}
