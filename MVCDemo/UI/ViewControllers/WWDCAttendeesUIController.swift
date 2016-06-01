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

import UIKit

final class WWDCAttendeesUIController {
    
    private unowned var view: UIView
    private let loadingView: LoadingView
    private let tableViewDataSource: TableViewDataSource<AttendeeCellController, AttendeeCell>
    
    var state: UIState = .Loading {
        willSet(newState) {
            update(newState)
        }
    }
    
    init(view: UIView, tableView: UITableView) {
        
        self.view = view
        self.loadingView = LoadingView(frame: CGRect(origin: .zero, size: tableView.frame.size))
        self.tableViewDataSource = TableViewDataSource<AttendeeCellController, AttendeeCell>(tableView: tableView)
        
        tableView.dataSource = tableViewDataSource
        update(state)
    }
}

extension WWDCAttendeesUIController: WWDCAttendesDelegate {
    
    func update(newState: UIState) {
        
        switch(state, newState) {
            
        case (.Loading, .Loading): loadingToLoading()
        case (.Loading, .Success(let attendees)): loadingToSuccess(attendees)
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    func loadingToLoading() {
        view.addSubview(loadingView)
        loadingView.frame = CGRect(origin: .zero, size: view.frame.size)
    }
    
    func loadingToSuccess(attendees: [Attendee]) {
        loadingView.removeFromSuperview()
        tableViewDataSource.dataSource = attendees.map(AttendeeCellController.init)
    }
}
