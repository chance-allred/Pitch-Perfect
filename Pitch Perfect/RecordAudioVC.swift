//
//  RecordAudioVC.swift
//  Pitch Perfect
//
//  Created by Chance Allred on 9/27/16.
//  Copyright © 2016 Chance Allred. All rights reserved.
//

import UIKit
import AVFoundation // Library for AVAudioRecorder

class RecordAudioVC: UIViewController, AVAudioRecorderDelegate {

    // MARK: Properties
    var recording = Bool() // Determine if recording or not
    var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupRecordButton()
        
    }
    
    func setupRecordButton() {
        // Round edges of button
        recordButton.layer.cornerRadius = 5
        recordButton.clipsToBounds = true
        recording = false // Not recording at launch
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        print("Record Button Pressed")
        
        // Animated Button Press. Code Complements: nRewik @ StackOverflow
        UIView.animate(withDuration: 0.2 , animations: {
            self.recordButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { finish in UIView.animate(withDuration: 0.9){
            self.recordButton.transform = CGAffineTransform.identity
            }
        })
        
        if !recording {
            print("Recording")
            recording = true // Start Recording
            recordButton.setTitle("Stop", for: .normal)
            recordButton.backgroundColor = UIColor(red:1.00, green:0.17, blue:0.18, alpha:1.00)
            
            startRecording() // Starts the recording of audio
            
        } else {
            print("Stopped")
            recording = false // Stop Recording
            recordButton.setTitle("Record", for: .normal)
            recordButton.backgroundColor = UIColor(red:0.38, green:0.78, blue:0.58, alpha:1.00)
            
            stopRecording() // Stops the recording of audio
        }
        
    }
    
    func startRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self // Set RecordAudioVC as the delegate
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    
    func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        // Ensures recording has finished and saved before segue
        if flag {
            performSegue(withIdentifier: "useRecordingSegue", sender: nil)
            print("AVAudioRecorder has finished recording")
        } else {
            print("Audio recording failed to save")
        }
    }
    
    
   
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "useRecordingSegue") {
//            let playSoundsVC = segue.destination as! PlaySoundsVC
//            let recordedAudioURL = sender as! NSURL
//            playSoundsVC.recordedAudioURL = recordedAudioURL
//        }
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

