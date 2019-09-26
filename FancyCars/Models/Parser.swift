//
//  Parser.swift
//  FancyCars
//
//  Created by Apple on 2019-09-25.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import Foundation

protocol Parser {
    func decode<T: Decodable>(from data: Data, to type: T.Type) -> T?
}

struct ParserImpl: Parser {
    func decode<T: Decodable>(from data: Data, to type: T.Type) -> T? {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(type, from: data) else {return nil}
        return decodedData
    }
}
