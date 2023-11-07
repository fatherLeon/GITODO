//
//  FakeRequestable.swift
//  GITODOTests
//
//  Created by 강민수 on 11/7/23.
//

@testable
import GITODO
import Foundation

struct FakeRequestable: Requestable {
    var url: URL? = URL(string: "https://www.naver.com")
    
    func makeUrlRequest(httpMethod: GITODO.HttpMethod) throws -> URLRequest {
        var request = URLRequest(url: self.url!)
        
        request.httpMethod = httpMethod.method
        
        return request
    }
}
