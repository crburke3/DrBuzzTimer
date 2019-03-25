//
//  Animator.swift
//  DrBuzzTimer
//
//  Created by Christian Burke on 1/5/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import AVKit

extension TimerViewController{
    func createVideoComposition(for playerItem: AVPlayerItem) -> AVVideoComposition {
        let videoSize = CGSize(width: 750, height: 2668 / 2.0)
        let composition = AVMutableVideoComposition(asset: playerItem.asset, applyingCIFiltersWithHandler: { request in
            let sourceRect = CGRect(origin: .zero, size: videoSize)
            let alphaRect = sourceRect.offsetBy(dx: 0, dy: sourceRect.height)
            let transform = CGAffineTransform(translationX: 0, y: -sourceRect.height)
            let filter = AlphaFrameFilter()
            filter.inputImage = request.sourceImage.cropped(to: alphaRect).transformed(by: transform)
            filter.maskImage = request.sourceImage.cropped(to: sourceRect)
            return request.finish(with: filter.outputImage!, context: nil)
        })
        
        composition.renderSize = videoSize
        return composition
    }
    
    
    func playAnimation(name:String){
        let screenSize: CGRect = UIScreen.main.bounds
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height:screenSize.height))
        myView.alpha = 0
        myView.tag = 100
        self.view.addSubview(myView)
        
        UIView.animate(withDuration: 1.0, animations: {
            myView.alpha = 1
        })
        if let files = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath ){
            for file in files {
                print(file)
            }
        }
        let videoUrl = Bundle.main.url(forResource: name, withExtension: "mp4")!
        let playerItem = AVPlayerItem(url: videoUrl)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.bounds = myView.bounds
        playerLayer.position = myView.center
        myView.layer.addSublayer(playerLayer)
        playerItem.videoComposition = createVideoComposition(for: playerItem)
        playerLayer.pixelBufferAttributes = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.0, execute: {
            UIView.animate(withDuration: 1.0, animations: {
                myView.alpha = 0
            })
            self.resetTimer(minutes: self.startMin, seconds: self.startSec)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            myView.removeFromSuperview()
        })
    }
    
    func resetTimer(minutes:Int = 0, seconds:Int = 0){
        isTimerFinished = false
        stopTimer()
        currMin = minutes
        currSec = seconds
        updateLabels()
    }
}
