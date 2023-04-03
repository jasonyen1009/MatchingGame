//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Yen Hung Cheng on 2023/4/1.
//

import Foundation


class MatchingGame {
    
    // 保存產生的每張 卡牌
    var cards: Array<Card> = Array()
    
    // 紀錄翻牌次數
    var flipcount = 0 {
        didSet {
            flipcount += 1
        }
    }
    
    // 紀錄第一張被翻開的卡牌 id
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                // 給定翻開對應的卡牌 id 給 indexOfOneAndOnlyFaceUpCard
                // 也就是第一次點選時，被翻開的卡片 id，翻開的 卡牌 id 就會給 foundIndex
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    // 在最初始遊戲時，點選第一張卡牌都會回傳 nil
                    }else {
                        return nil
                    }
                }
            }
            return foundIndex
        }set {
            // 給定 indexOfOneAndOnlyFaceUpCard = index 時，會觸發以下 迴圈
            // 這時會將一開始翻面的卡牌的 isFaceUp 設為 true
            // 因為 index 會跑完所有 cards ，而 只會有一個 index 會跟 newValue 值相同
            // 當有兩張卡牌已被翻面時，點選第三張，會將唯一的那張翻面卡牌設定翻面，其它牌都設為反面
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
                
            }

        }
    }
    
    
    func chooseCard(at index: Int)->Card{
        // 當點選到的卡牌沒有被配對時，會執行以下判斷式
        if !cards[index].isMatched{// isMatched = false
            // matchIndex 會是第一張被翻開的卡牌的 id
            // matchIndex != index 確保不為同張卡牌
            // 當有第一張卡牌翻開時點選第二張卡，才會執行以下判斷式
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                // 翻開第二張卡牌若是相同的卡牌，就執行以下判斷式
                // 將配對成功的卡牌的 isMatched 設為 true
                if cards[matchIndex].identifier == cards[index].identifier{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                // 將點選到的卡牌 isFaceUp 設為 true
                cards[index].isFaceUp = true
            }
            // 沒有卡片被翻開，或是兩張卡牌被翻開並選第三張卡牌，執行以下判斷式
            else{
                // 若是已經翻開的卡牌，再次點選將會把卡牌翻面
                if cards[index].isFaceUp == true{
                    cards[index].isFaceUp = false
                }else{
                    // 每次點擊第一張卡牌，會先將畫面中 UIButton 的 index 賦予 indexOfOneAndOnlyFaceUpCard 數值
                    indexOfOneAndOnlyFaceUpCard = index
                }
            }
        }
        
        return cards[index]
    }
    
    // 在初始化時，會傳入要產生的卡牌數量及 id 數量，由於卡牌是兩兩成對的，所以在每一個迴圈，會產生兩張同樣 id 的卡牌
    // 若有有 4 個的 emoji ，就會有 8 個 id
    init(numberOfPairsOfCards: Int) {
        
        for _ in 1...numberOfPairsOfCards {
            // 一次產生兩張卡牌
            let card = Card()
            // 更加有效率的寫法
            cards += [card, card]
            
        }
        
    }
    
}

