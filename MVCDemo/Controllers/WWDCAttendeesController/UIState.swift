//
//  UIState.swift
//  MVCDemo
//
//  Created by Mikis Woodwinter on 4/6/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

enum UIState {
    case loading
    case success([Attendee])
    case failure(Error)
}
