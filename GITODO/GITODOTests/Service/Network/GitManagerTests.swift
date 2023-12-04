//
//  GitManagerTests.swift
//  GITODOTests
//
//  Created by 강민수 on 11/28/23.
//

@testable
import GITODO
import XCTest
import RxTest
import RxSwift
import RxBlocking

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
    
    //MARK: Tests - Rx
    func test_올바른Repository를_반환하는지_확인_ByRx() {
        // given
        let expectationRepositoryCount = 3
        let expectationFirstFullName = "fatherLeon/baekjoon"
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        MockURLProtocol.requestHandler = { request in
            let fakeRequestable = FakeRequestable()
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.repositoryData.data(using: .utf8)!
            
            return (response, data)
        }
        
        // when
        let observable = gitManager.searchReposByRx(by: repoInfos.nickname, perPage: repoInfos.perPage, page: repoInfos.page)
            .subscribe(on: scheduler)
        
        // then
        do {
            let result = try observable.toBlocking().single()
            let resultRepositoryCount = result.count
            let resultFirstFullName = result.first!.fullName
            
            XCTAssertEqual(expectationRepositoryCount, resultRepositoryCount)
            XCTAssertEqual(expectationFirstFullName, resultFirstFullName)
        } catch {
            XCTFail("test_올바른Repository를_반환하는지_확인_ByRx")
        }
    }
    
    func test_네트워크_응답이_올바르지_못할경우_error를_반환() {
        // given
        let expectationError = NetworkError.invalidResponseError(statusCode: 403)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        MockURLProtocol.requestHandler = { request in
            let fakeRequestable = FakeRequestable()
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.repositoryData.data(using: .utf8)!
            
            return (response, data)
        }
        
        // when
        let observable = gitManager.searchReposByRx(by: repoInfos.nickname, perPage: repoInfos.perPage, page: repoInfos.page)
            .subscribe(on: scheduler)
        
        // then
        do {
            _ = try observable.toBlocking().single()
            XCTFail("test_네트워크_응답이_올바르지_못할경우_error를_반환")
        } catch {
            XCTAssertEqual(expectationError.localizedDescription, error.localizedDescription)
        }
    }
    
    func test_기존과_다른_데이터가_들어올경우_DecodingError반환() {
        // given
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        let expectationError = NetworkError.jsonDecodingError
        
        MockURLProtocol.requestHandler = { request in
            let fakeRequestable = FakeRequestable()
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.commitData.data(using: .utf8)!
            
            return (response, data)
        }
        
        // when
        let observable = gitManager.searchReposByRx(by: repoInfos.nickname, perPage: repoInfos.perPage, page: repoInfos.page)
            .subscribe(on: scheduler)
        
        // then
        do {
            _ = try observable.toBlocking().single()
            XCTFail("test_기존과_다른_데이터가_들어올경우_DecodingError반환")
        } catch {
            XCTAssertEqual(expectationError.localizedDescription, error.localizedDescription)
        }
    }
    
    func test_올바른Commit들을_반환하는지_확인_ByRx() {
        // given
        let expectationCommitCount = 3
        var isSuccess = false
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        MockURLProtocol.requestHandler = { request in
            let fakeRequestable = FakeRequestable()
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.commitData.data(using: .utf8)!
            
            return (response, data)
        }
        
        // when
        let observable = gitManager.searchCommitsByRx(by: commitInfos.fullName, since: commitInfos.since, until: commitInfos.until)
            .subscribe(on: scheduler)
        
        // then
        do {
            let result = try observable.toBlocking().single()
            let resultCommitCount = result.count
            isSuccess = true
            
            XCTAssertEqual(expectationCommitCount, resultCommitCount)
        } catch {
            XCTFail("test_올바른Commit들을_반환하는지_확인_ByRx")
        }
        
        XCTAssertTrue(isSuccess)
    }
    
    func test_searchCommitsByRx메서드_실행시_올바르지_않은_네트워크_응답이_올_경우_Error를_반환() {
        // given
        let expectationError = NetworkError.invalidResponseError(statusCode: 403)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        MockURLProtocol.requestHandler = { request in
            let fakeRequestable = FakeRequestable()
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.commitData.data(using: .utf8)!
            
            return (response, data)
        }
        // when
        let observable = gitManager.searchCommitsByRx(by: commitInfos.fullName, since: commitInfos.since, until: commitInfos.until)
            .subscribe(on: scheduler)
        
        // then
        do {
            _ = try observable.toBlocking().single()
            XCTFail("test_searchCommitsByRx메서드_실행시_올바르지_않은_네트워크_응답이_올_경우_Error를_반환")
        } catch {
            XCTAssertEqual(expectationError.localizedDescription, error.localizedDescription)
        }
    }
    
    func test_searchCommitsByRx메서드_실행시_다른_타입의_Json을_받을경우_Error를_반환() {
        // given
        let expectationError = NetworkError.jsonDecodingError
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        MockURLProtocol.requestHandler = { request in
            let fakeRequestable = FakeRequestable()
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.repositoryData.data(using: .utf8)!
            
            return (response, data)
        }
        // when
        let observable = gitManager.searchCommitsByRx(by: commitInfos.fullName, since: commitInfos.since, until: commitInfos.until)
            .subscribe(on: scheduler)
        
        // then
        do {
            _ = try observable.toBlocking().single()
            XCTFail("est_searchCommitsByRx메서드_실행시_다른_타입의_Json을_받을경우_Error를_반환")
        } catch {
            XCTAssertEqual(expectationError.localizedDescription, error.localizedDescription)
        }
    }
}
