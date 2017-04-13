//
//  MockedConnection.swift
//  MVCDemo
//
//  Created by Rui Peres on 30/05/2016.
//  Copyright © 2016 Razeware. All rights reserved.
//

import Foundation

final class MockedConnection: Connectable {

    fileprivate let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func connect(to resource: Resource, with completionHandler: @escaping ConnectionResponseHandler) {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        completionHandler(.success(data))
    }
}
