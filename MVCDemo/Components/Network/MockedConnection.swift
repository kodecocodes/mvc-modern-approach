//
//  MockedConnection.swift
//  MVCDemo
//
//  Created by Rui Peres on 30/05/2016.
//  Copyright © 2016 Razeware. All rights reserved.
//

import Foundation

final class MockedConnection: Connectable {

    private let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func makeConnection(resource: Resource, completion: (Result<Data, Error>) -> Void) {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        completion(.success(data))
    }
}
