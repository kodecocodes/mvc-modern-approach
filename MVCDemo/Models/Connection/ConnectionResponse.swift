//
//  ConnectionResponse.swift
//  MVCDemo
//
//  Created by Mikis Woodwinter on 4/7/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation

enum ConnectionResponse {
    case success(Data)
    case failure(ConnectionError)
}
