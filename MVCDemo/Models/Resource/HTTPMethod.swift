//
//  HTTPMethod.swift
//  MVCDemo
//
//  Created by Mikis Woodwinter on 4/7/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

enum HTTPMethod: String {
    case get
    case post
}

extension HTTPMethod: CustomStringConvertible {
    var description: String {
        return self.rawValue.uppercased()
    }
}
