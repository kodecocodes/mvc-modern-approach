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
    
    func makeConnection(resource: Resource, completion: Result<NSData, Error> -> Void) {
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        
        completion(.Success(data))
    }
}
