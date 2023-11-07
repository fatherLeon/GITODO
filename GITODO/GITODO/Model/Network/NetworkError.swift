//
//  NetworkError.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/23.
//

import Foundation

enum NetworkError: LocalizedError {
    case urlError
    case unknownError
    case invalidResponseError(statusCode: Int)
    case emptyDataError
    case jsonDecodingError
    
    var errorDescription: String? {
        switch self {
        case .urlError:
            return "올바르지 않은 URL입니다."
        case .unknownError:
            return "예상치 못한 에러입니다."
        case .invalidResponseError(let statusCode):
            return "HTTP Response \(statusCode) 잘못된 응답입니다."
        case .emptyDataError:
            return "데이터가 존재하지 않습니다."
        case .jsonDecodingError:
            return "잘못된 데이터 형식입니다."
        }
    }
}
