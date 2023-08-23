//
//  Decoder.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/23.
//

import Foundation

struct Decoder {
    func decodingJson<T: Decodable>(_ data: Data, by type: T.Type) throws -> T {
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedData = try jsonDecoder.decode(type, from: data)
            
            return decodedData
        } catch {
            throw NetworkError.jsonDecodingError
        }
    }
}
