/*
 * Copyright (c) 2015-2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

protocol Mappable {
    static func mapToModel(_ o: AnyObject) -> Result<Self, MyError>
}

func parse<T: Mappable>(_ data: Data, completion: (Result<[T], MyError>) -> Void) {
    
    let decodedData: Result<AnyObject, MyError> = decodeData(data)
        
    switch decodedData {
        
    case .success(let result):
        
        guard let array = result as? [AnyObject] else { completion(.failure(.parser)); return }
        
        let result: Result<[T], MyError> = arrayToModels(array)
        completion(result)
        
    case .failure:
        completion(.failure(.parser))
    }
}

private func arrayToModels<T: Mappable>(_ objects: [AnyObject]) -> Result<[T], MyError> {
    
    var convertAndCleanArray: [T] = []
    
    for object in objects {
        
        guard case .success(let model) = T.mapToModel(object) else { continue }
        convertAndCleanArray.append(model)
    }
    
    return .success(convertAndCleanArray)
}

private func decodeData(_ data: Data) -> (Result<AnyObject, MyError>) {
    
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
        return .success(json as AnyObject)
    }
    catch {
        return .failure(.parser)
    }
}
