//
//  GitManagerTests.swift
//  GITODOTests
//
//  Created by 강민수 on 11/28/23.
//

@testable
import GITODO
import XCTest

final class GitManagerTests: XCTestCase {
    
    private var gitManager: GitManager!
    
    private let repoInfos = (nickname: "abc", perPage: 100, page: 1)
    private let commitInfos = (fullName: "repo", since: Date(), until: Date())

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        gitManager = GitManager(session: urlSession)
    }

    override func tearDownWithError() throws {
        gitManager = nil
    }

    // MARK: Tests - escaping closure
    func test_올바른Repository를_반환하는지_확인() {
        // given
        let expectationReposCount = 3
        let expectation = XCTestExpectation()
        var isSuccess = false
        
        MockURLProtocol.requestHandler = { request in
            let fakeRequestable = FakeRequestable()
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.repositoryData.data(using: .utf8)!
            
            return (response, data)
        }
        
        // when
        gitManager.searchRepos(by: repoInfos.nickname, perPage: repoInfos.perPage, page: repoInfos.page) { repo in
            XCTAssertEqual(expectationReposCount, repo.count)
            isSuccess = true
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation])
        XCTAssertTrue(isSuccess)
    }
    
    func test_올바른Commit들을_반환하는지_확인() {
        // given
        let expectationCommitCount = 3
        let expectation = XCTestExpectation()
        var isSuccess = false
        
        MockURLProtocol.requestHandler = { request in
            let fakeRequestable = FakeRequestable()
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.commitData.data(using: .utf8)!
            
            return (response, data)
        }
        
        // when
        gitManager.searchCommits(by: commitInfos.fullName, since: commitInfos.since, until: commitInfos.until) { commits in
            XCTAssertEqual(expectationCommitCount, commits.count)
            isSuccess = true
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation])
        XCTAssertTrue(isSuccess)
    }
}
