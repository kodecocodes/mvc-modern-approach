//
//  JSONParserResult.swift
//  MVCDemo
//
//  Created by Mikis Woodwinter on 4/7/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

enum JSONParserResult<T> {
    case success(T)
    case failure(JSONParserError)
}
