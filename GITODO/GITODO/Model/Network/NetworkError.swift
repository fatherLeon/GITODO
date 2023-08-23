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
}
