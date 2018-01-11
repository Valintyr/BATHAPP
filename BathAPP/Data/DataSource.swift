//
//  DataSource.swift
//  BathAPP
//
//  Created by Charles Warnick on 1/11/18.
//  Copyright © 2018 ETDStudios. All rights reserved.
//

import UIKit

class DataSource {
    private var boardgames = [BoardGame]()
    private var immutableBoardGames = [BoardGame]()
    private var sections = [String]()
    
    var count: Int {
        return boardgames.count
    }
    
    var numberOfSections: Int {
        return sections.count
    }
    
    // MARK:- Public
    init() {
        boardgames = loadBoardGamesFromDisk()
        immutableBoardGames = boardgames
    }
    
    func deleteItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
        var indexes = [Int]()
        for indexPath in indexPaths {
            indexes.append(absoluteIndexForIndexPath(indexPath))
        }
        var newboardgames = [BoardGame]()
        for (index, boardgame) in boardgames.enumerated() {
            if !indexes.contains(index) {
                newboardgames.append(boardgame)
            }
        }
        boardgames = newboardgames
    }
    
    func moveBoardGameAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath) {
        if indexPath == newIndexPath {
            return
        }
        let index = absoluteIndexForIndexPath(indexPath)
        let boardGame = boardgames[index]
        boardGame.type = sections[newIndexPath.section]
        let newIndex = absoluteIndexForIndexPath(newIndexPath)
        boardgames.remove(at: index)
        boardgames.insert(boardGame, at: newIndex)
    }
    
    func newRandomBoardGame() -> IndexPath {
        let index = Int(arc4random_uniform(UInt32(immutableBoardGames.count)))
        let boardgameToCopy = immutableBoardGames[index]
        let newBoardGame = BoardGame(copying: boardgameToCopy)
        boardgames.append(newBoardGame)
        return IndexPath(row: boardgames.count - 1, section: 0)
    }
    
    func indexPathForNewRandomBoardGame() -> IndexPath {
        let index = Int(arc4random_uniform(UInt32(immutableBoardGames.count)))
        let boardgameToCopy = immutableBoardGames[index]
        let newBoardGame = BoardGame(copying: boardgameToCopy)
        boardgames.append(newBoardGame)
        boardgames.sort { $0.index < $1.index }
        return indexPathForBoardGame(newBoardGame)
    }
    
    func indexPathForBoardGame(_ boardgame: BoardGame) -> IndexPath {
        let section = 0
        var item = 0
        for (index, currentBoardGame) in boardGamesForSection(section).enumerated() {
            if currentBoardGame === boardgame {
                item = index
                break
            }
        }
        return IndexPath(item: item, section: section)
    }
    
    func numberOfBoardGamesInSection(_ index: Int) -> Int {
        let boardgames = boardGamesForSection(index)
        return boardgames.count
    }
    
    func boardgameForItemAtIndexPath(_ indexPath: IndexPath) -> BoardGame? {
        if indexPath.section > 0 {
            let boardgames = boardGamesForSection(indexPath.section)
            return boardgames[indexPath.item]
        } else {
            return boardgames[indexPath.item]
        }
    }
    
    func titleForSectionAtIndexPath(_ indexPath: IndexPath) -> String? {
        if indexPath.section < sections.count {
            return sections[indexPath.section]
        }
        return nil
    }
    
    
    // MARK:- Private
    private func loadBoardGamesFromDisk() -> [BoardGame] {
        sections.removeAll(keepingCapacity: false)
        if let path = Bundle.main.path(forResource: "BoardGames", ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                var boardgames: [BoardGame] = []
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let name = dict["name"] as! String
                        let description = dict["description"] as! String
                        let manufacturer = dict["publishDate"] as! String
                        let publishDate = dict["publishDate"] as! String
                        let type = dict["type"] as! String
                        let photo = dict["photo"] as! String
                        let index = dict["index"] as! Int
                        let boardgame = BoardGame(name: name,description: description, manufacturer: manufacturer, publishDate: publishDate,type:type, photo: photo, index: index)

                        boardgames.append(boardgame)
                    }
                }
                return boardgames
            }
        }
        return []
    }
    
    private func absoluteIndexForIndexPath(_ indexPath: IndexPath) -> Int {
        var index = 0
        for i in 0..<indexPath.section {
            index += numberOfBoardGamesInSection(i)
        }
        index += indexPath.item
        return index
    }
    
    private func boardGamesForSection(_ index: Int) -> [BoardGame] {
        let section = sections[index]
        let boardgamesInSection = boardgames.filter { (boardgame: BoardGame) -> Bool in
            return boardgame.type == section
        }
        return boardgamesInSection
    }
    
}
