//
//  Card.swift
//  MatchingGame
//
//  Created by Yen Hung Cheng on 2023/4/1.
//

import Foundation

struct Card {
    // 判斷卡牌是否翻面
    var isFaceUp: Bool = false
    // 判斷卡牌是否配對
    var isMatched: Bool = false
    // 每張卡牌的 id
    var identifier: Int
    
    
    // 每產生一張卡牌就產生 i+1 的 id 給它，從 1 開始產生
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
