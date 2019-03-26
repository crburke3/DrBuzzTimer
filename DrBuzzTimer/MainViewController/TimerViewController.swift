//
//  ViewController.swift
//  DrBuzzTimer
//
//  Created by Christian Burke on 12/30/18.
//  Copyright © 2018 Christian Burke. All rights reserved.
//

import UIKit
import AVKit



class TimerViewController: UIViewController {
    
    let animArray = ["trippy", "pinklady", "Stripper", "loopy", "hula"]
    
    
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var minView: UIView!
    @IBOutlet var secView: UIView!
    
    @IBOutlet var minutesLbl: UILabel!
    @IBOutlet var secondsLbl: UILabel!
    @IBOutlet var timerButton: UIButton!
    @IBOutlet var drBuzzImage: UIImageView!
    var isTimerRunning = false
    var isTimerFinished = false
    
    weak var timer: Timer?
    let startMin = 20
    let startSec = 0
    var currMin = 0
    var currSec = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        currMin = startMin
        currSec = startSec
        minView.layer.borderWidth = 1
        minView.layer.borderColor = UIColor.white.cgColor
        secView.layer.borderWidth = 1
        secView.layer.borderColor = UIColor.white.cgColor
        timerButton.layer.cornerRadius = 10
        timerButton.clipsToBounds = true
    }
    
    @IBAction func StartTimer(_ sender: Any) {
        if(!isTimerRunning){
            startTimer()
            timerButton.setTitle("Pause", for: .normal)
            isTimerRunning = true
            skipButton.isHidden = false
        }else{
            stopTimer()
            timerButton.setTitle("START NOW", for: .normal)
            isTimerRunning = false
            skipButton.isHidden = true
        }
    }
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        let point = touch.location(in: self.view)
        if let viewWithTag = self.view.viewWithTag(100) {
            //print("animView")
            if let player = viewWithTag.subviews[0]{
                
            }
            viewWithTag.removeFromSuperview()
        }
        else {
            print("tag not found")
        }
    }
 */
    
    @IBAction func skipButton(_ sender: Any) {
        self.currMin = 0
        self.currSec = 5
    }
    
    
    func startTimer() {
        timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        if(isTimerFinished){
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            // do something here
            if(self!.currSec == 0){
                if(self!.currMin == 0){
                    if(!self!.isTimerFinished){
                        let randNumber = Int.random(in: 0 ..< self!.animArray.count)
                        self!.playAnimation(name: self!.animArray[randNumber])
                    }
                    self!.isTimerFinished = true
                    self!.skipButton.isHidden = true
                    return
                }
                self!.currMin -= 1
                self!.currSec = 59
            }else{
                self!.currSec -= 1
            }
            self!.updateLabels()
            self!.pulseImage(img: self!.drBuzzImage)
        }
    }
    
    func stopTimer() {
        timerButton.setTitle("Start Timer", for: .normal)
        isTimerRunning = false
        timer?.invalidate()
    }
    
    deinit {
        stopTimer()
    }
    
    func updateLabels(){
        minutesLbl.text = String(currMin)
        secondsLbl.text = String(currSec)
    }
    
    func pulseImage(img:UIImageView){
        UIView.animate(withDuration: 0.5, animations: {
            img.alpha = 0.5
        }) {_ in
            UIView.animate(withDuration: 0.5, animations: {
                img.alpha = 1
            })
        }
    }
}

