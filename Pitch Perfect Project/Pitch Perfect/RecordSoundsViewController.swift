//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Stephanie Truchan on 3/5/15.
//  Copyright (c) 2015 Stephanie Truchan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
   
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var TapInstruction: UILabel!
    
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true
        //enable record button
        recordButton.enabled = true
        //display Tap Instruction
        TapInstruction.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        //provide a stop button once the recording has started
        stopButton.hidden = false
        //disable record button once user has started a recording
        recordButton.enabled = false
        // Hide the Tap Instruction once the user has started Recording
        TapInstruction.hidden = true
        
        //Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

        
        println("in recordAudio")
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
       // make sure code only runs if the recording finished successfully
        
        if(flag){
            
        //Step 1 - Save the recorded audio
        
        // Initialize object
        recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
       
        //set attributes of object
        recordedAudio.filePathUrl = recorder.url
        //get name of recorded file
        recordedAudio.title = recorder.url.lastPathComponent

        
        //Step 2 - Move to the next scene aka perform segue
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
       
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
        /* ensure the right view controller is doing segue for this function since
       multiple view controllers can segue to same destination view controller*/
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController

            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
        //Stop recording the user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
}

