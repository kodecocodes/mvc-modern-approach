//
//  WWDCAttendeesHandler.swift
//  MVCDemo
//
//  Created by Mikis Woodwinter on 4/6/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

protocol WWDCAttendeesHandler: class {
    var delegate: WWDCAttendesDelegate? { get set }
    func fetchAttendees()
}
