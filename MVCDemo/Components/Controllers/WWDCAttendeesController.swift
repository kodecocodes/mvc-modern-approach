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

enum UIState {
    case loading
    case success([Attendee])
    case failure(MyError)
}

protocol WWDCAttendesDelegate: class {
    var state: UIState { get set}
}

protocol WWDCAttendeesHandler: class {
    
    var delegate: WWDCAttendesDelegate? { get set }
    func fetchAttendees()
}

final class WWDCAttendeesController: WWDCAttendeesHandler {
    
    fileprivate let connectable: Connectable
    var delegate: WWDCAttendesDelegate?
    
    init(connectable: Connectable) {
        self.connectable = connectable
    }
    
    func fetchAttendees() {
        
        guard let delegate = self.delegate else { fatalError("did you forget to set the delegate?")}
        
        delegate.state = .loading
        let resource = Resource(path: "/u/14102938/attendees.json", method: .GET)
        
        let parsingCompletion = createParsingCompletion(delegate)
        let networkCompletion = createNetworkCompletion(delegate, parseCompletion: parsingCompletion)
        
        connectable.makeConnection(resource, completion: networkCompletion)
    }
}

private typealias ParseCompletion = (Result<[Attendee], MyError>) -> Void
private typealias NetworkCompletion = (Result<Data, MyError>) -> Void

private func createParsingCompletion(_ delegate: WWDCAttendesDelegate) -> ParseCompletion {
    
    return { atendeesResult in
        DispatchQueue.main.async {
            switch atendeesResult {
            case .success(let atendees): delegate.state = .success(atendees)
            case .failure(let error): delegate.state = .failure(error)
            }
        }
    }
}

private func createNetworkCompletion(_ delegate: WWDCAttendesDelegate, parseCompletion: @escaping ParseCompletion) -> NetworkCompletion {
    
    return { dataResult in
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            print(dataResult)
            switch dataResult {
            case .success(let data): parse(data, completion: parseCompletion)
            case .failure(let error): delegate.state = .failure(error)
            }
        }
    }
}
