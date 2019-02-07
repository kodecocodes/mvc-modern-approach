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

public typealias Headers = [String: String]

public struct Resource {
    
    public let path: String
    public let method: Method
    
    public var description: String {
        return "Path:\(path)\nMethod:\(method.rawValue)\n"
    }
}

public enum Method: String {
    case GET
    case POST
}

extension Resource {
    
    /// Used to transform a Resource into a NSURLRequest
    public func toRequest(baseURL: URL) -> URLRequest {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        components?.path = path
        
        let finalURL = components?.url ?? baseURL
        var request = URLRequest(url: finalURL)
        
        request.httpMethod = method.rawValue
        
        return request
    }
}
