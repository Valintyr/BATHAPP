//
//  BoardGame.swift
//  BathAPP
//
//  Created by Charles Warnick on 1/11/18.
//  Copyright © 2018 ETDStudios. All rights reserved.
//

import UIKit

class BoardGame {
    var name: String
    var description: String
    var manufacturer: String
    var publishDate: String
    var type: String
    var photo: String
    var index: Int
    
    init(name: String, description: String,manufacturer: String, publishDate: String, type: String, photo: String, index: Int) {
        self.name = name
        self.description = description
        self.manufacturer = manufacturer
        self.publishDate = publishDate
        self.type = type
        self.photo = photo
        self.index = index
    }
    
    convenience init(copying boardgame: BoardGame) {
        self.init(name: boardgame.name,description: boardgame.description, manufacturer: boardgame.manufacturer, publishDate: boardgame.publishDate,type:boardgame.type, photo: boardgame.photo, index: boardgame.index)
    }
}
