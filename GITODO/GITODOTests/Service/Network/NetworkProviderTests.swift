//
//  NetworkProviderTests.swift
//  GITODOTests
//
//  Created by 강민수 on 11/7/23.
//

@testable
import GITODO
import XCTest

final class NetworkProviderTests: XCTestCase {

    var networkProvider: NetworkProvider!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        networkProvider = NetworkProvider(session: urlSession)
    }

    override func tearDownWithError() throws {
        networkProvider = nil
    }

    // MARK: request - escaping closure
    func test_올바른_데이터_입력시_Data확인() {
        // given
        let fakeRequestable = FakeRequestable()
        let expectationRepositoryCount = 3
        var isSuccess = false
        let expectation = XCTestExpectation(description: "test_올바른_데이터_입력시_Data확인")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.repositoryData.data(using: .utf8)!
            
            return (response, data)
        }
        
        // when
        try! networkProvider.request(by: GitRepositories.self, with: fakeRequestable) { result in
            switch result {
            case .success(let data):
                guard let data = data as? GitRepositories else {
                    XCTFail("test_올바른_데이터_입력시_Data확인 - JsonDecoding 파싱 문제")
                    return
                }
                
                isSuccess = true
                print(data.count)
                XCTAssertEqual(expectationRepositoryCount, data.count)
                expectation.fulfill()
            case .failure(_):
                XCTFail("test_올바른_데이터_입력시_Data확인 - 성공해야만 하는 테스트케이스")
            }
        }
        
        // then
        wait(for: [expectation])
        XCTAssertTrue(isSuccess)
    }
    
    func test_Decodable_Type_입력이_잘못될경우_DecodingError가_표시됨() {
        // given
        let fakeRequestable = FakeRequestable()
        let expectationError = NetworkError.jsonDecodingError
        var isSuccess = false
        let expectation = XCTestExpectation(description: "test_Decodable_Type_입력이_잘못될경우_DecodingError가_표시됨")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.repositoryData.data(using: .utf8)!
            
            return (response, data)
        }
        
        // when
        try! networkProvider.request(by: GitCommits.self, with: fakeRequestable, { result in
            switch result {
            case .success(_):
                XCTFail("test_Decodable_Type_입력이_잘못될경우_DecodingError가_표시됨 - 실패해야하는 테스트케이스")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, expectationError.localizedDescription)
                isSuccess = true
                expectation.fulfill()
            }
        })
        
        // then
        wait(for: [expectation])
        XCTAssertTrue(isSuccess)
    }
    
    func test_잘못된_URLResponse응답일경우_ResponseError가_표시됨() {
        // given
        let fakeRequestable = FakeRequestable()
        let expectationError = NetworkError.invalidResponseError(statusCode: 403)
        var isSuccess = false
        let expectation = XCTestExpectation(description: "test_잘못된_URLResponse응답일경우_ResponseError가_표시됨")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: fakeRequestable.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!
            let data = DummyNetworkData.repositoryData.data(using: .utf8)!
            
            return (response, data)
        }
        
        // when
        try! networkProvider.request(by: GitRepositories.self, with: fakeRequestable, { result in
            switch result {
            case .success(_):
                XCTFail("test_잘못된_URLResponse응답일경우_ResponseError가_표시됨 - 실패해야하는 테스트 케이스")
            case .failure(let error):
                guard let error = error as? NetworkError else {
                    XCTFail("test_잘못된_URLResponse응답일경우_ResponseError가_표시됨 - 타입 캐스팅 실패")
                    return
                }
                
                XCTAssertEqual(error.localizedDescription, expectationError.localizedDescription)
                isSuccess = true
                expectation.fulfill()
            }
        })
        
        // then
        wait(for: [expectation])
        XCTAssertTrue(isSuccess)
    }

    // MARK: requestByRx
}
