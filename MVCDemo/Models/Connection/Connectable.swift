//
//  ConnectionResponse.swift
//  MVCDemo
//
//  Created by Mikis Woodwinter on 4/7/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

typealias ConnectionResponseHandler = (ConnectionResponse) -> Void

protocol Connectable {
    func connect(to resource: Resource, with completionHandler: @escaping ConnectionResponseHandler)
}
