//
//  Array++Extension.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/22.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard (0..<self.count).contains(index) else {
            return nil
        }
        
        return self[index]
    }
}
