//
//  JSONConvertible.swift
//  MVCDemo
//
//  Created by Mikis Woodwinter on 4/7/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

typealias JSON = [String: AnyObject]

protocol JSONConvertible {
    static func model(for json: JSON) -> Self?
}
