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
    var recording = false // Determine if recording or not
    var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var animationImageView: UIImageView!
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupRecordButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupRecordButton() {
        
        /* Solution to bug: LayoutSubviews was causing bugs & cornerRadius woulden't work any other way. 
         DispatchQueue seemed to be the solution.
         */
        DispatchQueue.main.async {
            // Round edges of button
            self.recordButton.layer.cornerRadius = 0.5 * self.recordButton.bounds.size.width
            self.recordButton.layer.masksToBounds = true
            self.recording = false // Not recording at launch
        }
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        print("Record Button Pressed")
        animateButtonPress()
        
        if !recording {
            print("Recording")
            loadAnimation()
            
            recording = true // Start Recording
            recordButton.setTitle("Stop", for: .normal)
            recordButton.backgroundColor = UIColor(red:1.00, green:0.15, blue:0.37, alpha:1.00)
            
            startRecording() // Starts the recording of audio
            
        } else {
            print("Stopped")
            stopAnimation()
            
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
            // .url is stored recording sent to prepare for segue.
            performSegue(withIdentifier: "useRecordingSegue", sender: audioRecorder.url)
            print("AVAudioRecorder has finished recording")
        } else {
            print("Audio recording failed to save")
        }
    }
    
    func animateButtonPress() {
        // Animated Button Press. Code Complements: nRewik @ StackOverflow
        UIView.animate(withDuration: 0.2 , animations: {
            self.recordButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { finish in UIView.animate(withDuration: 0.9){
                self.recordButton.transform = CGAffineTransform.identity
                }
        })
    }
    
    func loadAnimation() {
        var imgListArray = [UIImage]()
        for countValue in 1...20
        {
            
            let strImageName : String = "circle_\(countValue).png"
            let image  = UIImage(named:strImageName)
            imgListArray.append(image!)
        }
        
        self.animationImageView.animationImages = imgListArray
        self.animationImageView.animationDuration = 1.0
        self.animationImageView.startAnimating()
    }
    
    func stopAnimation() {
        self.animationImageView.stopAnimating()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "useRecordingSegue") {
            let playSoundsVC = segue.destination as! PlaySoundsVC
            
            let recordedAudio = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudio
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

