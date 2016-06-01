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
    case Loading
    case Success([Attendee])
    case Failure(Error)
}

protocol WWDCAttendesDelegate: class {
    var state: UIState { get set}
}

protocol WWDCAttendeesHandler: class {
    
    var delegate: WWDCAttendesDelegate? { get set }
    func fetchAttendees()
}

final class WWDCAttendeesController: WWDCAttendeesHandler {
    
    private let connectable: Connectable
    var delegate: WWDCAttendesDelegate?
    
    init(connectable: Connectable) {
        self.connectable = connectable
    }
    
    func fetchAttendees() {
        
        guard let delegate = self.delegate else { fatalError("did you forget to set the delegate?")}
        
        delegate.state = .Loading
        let resource = Resource(path: "/u/14102938/attendees.json", method: .GET)
        
        let parsingCompletion = createParsingCompletion(delegate)
        let networkCompletion = createNetworkCompletion(delegate, parseCompletion: parsingCompletion)
        
        connectable.makeConnection(resource, completion: networkCompletion)
    }
}

private typealias ParseCompletion = Result<[Attendee], Error> -> Void
private typealias NetworkCompletion = Result<NSData, Error> -> Void

private func createParsingCompletion(delegate: WWDCAttendesDelegate) -> ParseCompletion {
    
    return { atendeesResult in
        dispatch_async(dispatch_get_main_queue()) {
            switch atendeesResult {
            case .Success(let atendees): delegate.state = .Success(atendees)
            case .Failure(let error): delegate.state = .Failure(error)
            }
        }
    }
}

private func createNetworkCompletion(delegate: WWDCAttendesDelegate, parseCompletion: ParseCompletion) -> NetworkCompletion {
    
    return { dataResult in
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            print(dataResult)
            switch dataResult {
            case .Success(let data): parse(data, completion: parseCompletion)
            case .Failure(let error): delegate.state = .Failure(error)
            }
        }
    }
}
