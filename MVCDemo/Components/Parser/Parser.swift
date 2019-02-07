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
    static func mapToModel(o: Any) -> Result<Self, Error>
}

func parse<T: Mappable>(data: Data, completion: (Result<[T], Error>) -> Void) {
    
    let decodedData: Result<Any, Error> = decodeData(data: data)
        
    switch decodedData {
        
    case .success(let result):
        
        guard let array = result as? [Any] else { completion(.failure(.parser)); return }
        
        let result: Result<[T], Error> = arrayToModels(objects: array)
        completion(result)
        
    case .failure:
        completion(.failure(.parser))
    }
}

private func arrayToModels<T: Mappable>(objects: [Any]) -> Result<[T], Error> {
    
    var convertAndCleanArray: [T] = []
    
    for object in objects {
        
        guard case .success(let model) = T.mapToModel(o: object) else { continue }
        convertAndCleanArray.append(model)
    }
    
    return .success(convertAndCleanArray)
}

private func decodeData(data: Data) -> Result<Any, Error> {
    
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
        return .success(json)
    }
    catch {
        return .failure(.parser)
    }
}
