//
//  ViewController.swift
//  omikujiApp
//
//  Created by 梶原敬太 on 2019/06/08.
//  Copyright © 2019 梶原敬太. All rights reserved.
//

import UIKit
import AVFoundation
//音を鳴らすためにこの1行を追記


class ViewController: UIViewController {
    // 結果を表示したときに音を出すための再生オブジェクトを格納します。
    var resultAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    var resultAudioPlayer2: AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var stickView: UIView!
    @IBOutlet weak var stickLabel: UILabel!
    @IBOutlet weak var stickHeight: NSLayoutConstraint!
    @IBOutlet weak var stickButtomMargin: NSLayoutConstraint!
    
//    おみくじの結果を格納した配列
    let resultTexts: [String] = [
        "大吉",
        "中吉",
        "小吉",
        "吉",
        "末吉",
        "凶",
        "大凶",
        "ごぼう"
    ]
    
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var bigLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSound()
        setupSound2()
        // Do any additional setup after loading the view.
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion != UIEvent.EventSubtype.motionShake || overView.isHidden == false{
            // シェイクモーション以外では動作させない
            // 結果の表示中は動作させない
            return
        }

        
        /*arc4random_uniformはランダム関数でresultTexts配列の数からランダムに
         arc4random_uniform関数は、0〜引数にとった値-1 の範囲の整数をランダムに返す関数*/
        let resultNum = Int(arc4random_uniform(UInt32(resultTexts.count)))
        
/*CGFloatこれは座標（x，y）や画像のサイズ（width,Height）などに入れる「数値」が入る型。Double型もしくはFloat型から変換できる。*/
        if stickButtomMargin.constant == CGFloat(0){
            stickLabel.text = resultTexts[resultNum]
        }else {
            return
        }
        //        rabelにランダムでとってきたものが入る
        
        stickButtomMargin.constant = stickHeight.constant * -1
        //結果表示のときに音を再生(Play)する！
        self.resultAudioPlayer2.play()
        
        //        1秒でアニメーションを実行する
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
            
        },completion: { (finished: Bool) in
            //  アニメーション後に スティックから出てきた文字と一緒にする
            self.bigLabel.text = self.stickLabel.text
            
            // 裏側に隠さなくする
            //結果にアニメーションをつけた
            self.overView.alpha = 0.0
            UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseIn], animations: {
                self.overView.alpha = 1.0
            }, completion: nil)

            self.overView.isHidden = false
            
            //結果表示のときに音を再生(Play)する！
            self.resultAudioPlayer.play()
            
        })
    }
    //リセットボタン
    @IBAction func tapRetryButton(_ sender: Any) {
        
        overView.isHidden = true
        stickButtomMargin.constant = 0
        /*    1行目でoverViewをisHiddenを有効にして再び非表示にしています。
         2行目では、シェイク時に変更された制約の値を0に戻して、
         再度おみくじ棒が本体の中に隠れるようにしています。*/
    }
    //結果表示するときに鳴らす音の準備 再生する音楽ファイルを読み込む関数 try!
    func setupSound() {
        if let sound = Bundle.main.path(forResource: "drum", ofType: ".mp3") {
            resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            
            resultAudioPlayer.prepareToPlay()
        }
        
    }
    
    
    func setupSound2() {
        if let sound = Bundle.main.path(forResource: "bell", ofType: ".mp3") {
            resultAudioPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            
            resultAudioPlayer2.prepareToPlay()
        }
        
    }
}

