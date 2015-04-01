//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Stephanie Truchan on 3/20/15.
//  Copyright (c) 2015 Stephanie Truchan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    //declare global variable
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize variable
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        //convert NSUrl to AVAudio File & Initialize
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowly(sender: UIButton) {
        playAudioAtDifferentRate(0.5)
    }
    
    
    @IBAction func playFast(sender: UIButton) {
        playAudioAtDifferentRate(2.0)
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
       //audioPlayer.stop()
        stopAudioResetAudioAndEngine()
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
      playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
      playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
       
        stopAudioResetAudioAndEngine()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
                
        audioPlayerNode.play()
        
    }
    
    func stopAudioResetAudioAndEngine (){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioAtDifferentRate(rate:Float){
        //This function plays audio at different speeds
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        stopAudioResetAudioAndEngine()
        audioPlayer.play()
    }
    
    
}
