//
//  JSONParser.swift
//  MVCDemo
//
//  Created by Mikis Woodwinter on 4/7/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation

struct JSONParser {
    private static func decode(_ data: Data) -> JSONParserResult<[AnyObject]> {
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            
            guard let jsonArray = json as? [AnyObject] else { return .failure(.invalidJSON) }
            
            return .success(jsonArray)
        } catch {
            return .failure(.invalidJSON)
        }
    }
    
    public static func parse<T: JSONConvertible>(_ data: Data, with completionHandler: (JSONParserResult<[T]>) -> Void) {
        
        let decodedJSON = JSONParser.decode(data)
        
        switch decodedJSON {
        case .success(let jsonData):
            guard let jsonArray = jsonData as? [JSON] else {
                completionHandler(.failure(.invalidJSON))
                return
            }
            
            let models = jsonArray.flatMap(T.model)
    
            completionHandler(.success(models))
        case.failure(let error):
            completionHandler(.failure(error))
        }
    }
}
