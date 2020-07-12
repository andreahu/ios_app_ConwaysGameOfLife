//
//  Configuration.swift
//  FinalProject
//
//  Created by AH on 8/3/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import Foundation

struct Configuration : Encodable, Decodable {
    private enum CodingKeys : String, CodingKey {
        case title = "title"
        case contents = "contents"
    }
    let title : String?
    let contents: [[Int]]?
    
    init(t: String, c: [[Int]]) {
        self.title = t
        self.contents = c
    }
}
