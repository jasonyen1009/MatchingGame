//
//  ViewController.swift
//  MatchingGame
//
//  Created by Yen Hung Cheng on 2023/3/31.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var cardsButton: [UIButton]!
    
    @IBOutlet weak var flipcountLable: UILabel!
    
    // +1 是為了確保牌數
    // lazy 等元件都好了之後，再去初始化
    // 使用 lazy 的話，didSet 就無法使用
    lazy var game: MatchingGame = MatchingGame(numberOfPairsOfCards: (cardsButton.count+1) / 2)
    
    // emoji 保存 每個卡牌的 id 與 顯示符號
    var emoji = Dictionary<Int,String>()
    var emojiChooices = ["😁", "💀", "👻", "🐶", "🐳", "🐢", "🐭", "🐵"]
    let copyEmoji = ["😁", "💀", "👻", "🐶", "🐳", "🐢", "🐭", "🐵"]

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 打亂卡片排列
        cardsButton.shuffle()
        // 更新 flipcountLable
        updateFlipCountLabel()

    }
    
    // 回傳表情符號
    func getEmoji(for card: Card)->String{
        if emoji[card.identifier] == nil, emojiChooices.count>0{
            // random 一個數值
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChooices.count)))
            // 從 emojiChooices 中隨機加入一個 emoji 後，使用 rmove 移除加入的 emoji
            emoji[card.identifier] = emojiChooices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    // 更新 button NSAttributedString
    func updateFont(sender: UIButton, string: String) {
        let font = UIFont.systemFont(ofSize: 50)
        let attributes = [NSAttributedString.Key.font: font]
        let message = NSAttributedString(string: string, attributes: attributes)
        sender.setAttributedTitle(message, for: .normal)
    }
    
    // 更新卡牌畫面
    func updateViewFromModel() {
        // 判斷所有的 cardsButton
        for index in cardsButton.indices {
            let button = cardsButton[index]
            let card = game.cards[index]
            
            // 判斷卡是否配對到了
            if !card.isMatched { //isMatched = false
                // 還沒配對就執行以下程式
                if !card.isFaceUp {//
                    updateFont(sender: button, string: "")
                    button.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.3176470588, blue: 0.231372549, alpha: 1)
                }else {
                    updateFont(sender: button, string: getEmoji(for: card))
                    button.backgroundColor = #colorLiteral(red: 0.9432101846, green: 0.953361094, blue: 0.8697650433, alpha: 1)
                }
            }else {
                updateFont(sender: button, string: getEmoji(for: card))
                button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                // 確保 flipcount 不再更新，將 isEnabled 關閉
                button.isEnabled = false
            }
            
        }
    }
    
    // 更新 label NSAttributedString
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 30),
            .strokeColor: UIColor.darkGray,
            // 裡面填滿要寫 -1, 3 會是空心的
            .strokeWidth: -1,
            .foregroundColor: UIColor.darkGray
        
        ]
        
        let attribtext = NSAttributedString(string: "Flips:   \(game.flipcount / 2)", attributes: attributes)
        flipcountLable.attributedText = attribtext
        
    }
    
    
    
    
    
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        // 抓取點選的 button id
        // 將抓取到的 id 傳送到 game.chooseCard(at: cardNumber) 中
        if let cardNumber = cardsButton.firstIndex(of: sender){
            let _ = game.chooseCard(at: cardNumber)
            // 增加翻牌效果
            UIView.transition(with: cardsButton[cardNumber], duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            // 更新卡牌畫面
            updateViewFromModel()
            // 增加翻牌次數
            game.flipcount += 1
            // 更新 flipcountLable
            updateFlipCountLabel()
            
        }
        
    }
    
    
    @IBAction func check(_ sender: UIButton) {
        // 翻開所有 卡牌
        // 並更新每張卡牌的狀態
        for i in game.cards.indices {
            game.cards[i].isFaceUp = true
            game.cards[i].isMatched = true
        }
        // 更新卡牌畫面
        updateViewFromModel()
        // 將翻牌次數歸 0
        game.flipcount = 0
        // 更新 flipcountLable
        updateFlipCountLabel()
        
    }
    
    @IBAction func ResetButton(_ sender: UIButton) {
        
        // 設定所有卡牌 isFaceUp isMatched 為 fasle
        for i in game.cards.indices {
            game.cards[i].isFaceUp = false
            game.cards[i].isMatched = false
        }
        // 讓所有 button 都能點選
        for i in cardsButton.indices {
            cardsButton[i].isEnabled = true
        }
        // 更新卡牌畫面
        updateViewFromModel()
        // flipcount 歸 0
        game.flipcount = 0
        // 再次填充 emojiChooices
        emojiChooices = copyEmoji
        // 再次 shuffle emojiChooices
        emojiChooices.shuffle()
        // 再次 shuffle cardsButton
        cardsButton.shuffle()
        // 移除舊有的 emoji
        emoji.removeAll()
        // 更新 flipcountLable
        updateFlipCountLabel()
        

    }
    
    
    

}

