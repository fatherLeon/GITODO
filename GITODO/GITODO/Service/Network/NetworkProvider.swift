//
//  NetworkManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/22.
//

import Foundation

final class NetworkProvider {
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<D: Decodable, R: Requestable>(with endPoint: R, _ completion: @escaping ((Result<D, Error>) -> Void)) throws {
        do {
            let request = try endPoint.makeUrlRequest(httpMethod: .GET)
            
            session.dataTask(with: request) { [weak self] data, response, error in
                self?.checkError(data, response, error) { result in
                    switch result {
                    case .success(let data):
                        do {
                            let decodingData = try Decoder().decodingJson(data, by: D.self)
                            
                            completion(.success(decodingData))
                        } catch {
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.resume()
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func checkError(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completion: @escaping ((Result<Data, Error>) -> Void)) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.unknownError))
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(NetworkError.invalidResponseError(statusCode: httpResponse.statusCode)))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.emptyDataError))
            return
        }
        
        completion(.success(data))
    }
}
