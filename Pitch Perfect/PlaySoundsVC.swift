//
//  PlaySoundsVC.swift
//  Pitch Perfect
//
//  Created by Chance Allred on 9/29/16.
//  Copyright © 2016 Chance Allred. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsVC: UIViewController {
    
    // MARK: Properties
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer! // Replaced by NSTimer in Swift 3
    
    enum ButtonType: Int { case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb}
    
    // MARK: Outlets
    @IBOutlet weak var stopPlaybackButton: UIButton!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        print("Play Sound Button Pressed")
        
        animateButtonPress(button: sender)
        
        switch ButtonType(rawValue: sender.tag)! {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -800)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        } // No Default, all cases presented
        configureUI(playState: .Playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        print("Stop Audio Button Pressed")
        animateButtonPress(button: sender as! UIButton)
        stopAudio()
    }
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupStopButton()
        setupAudio() // Had to reconfigure the whole extension due to out-of-date code.
        
        /*Observes orientation of screen for button positioning */
        NotificationCenter.default.addObserver(self, selector: #selector(PlaySoundsVC.screenOrientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // Check the screen orientation upon entering
        screenOrientationChanged()
    }
    
    func screenOrientationChanged() {
        /* Upon landscape orientation, remove the NavBar*/
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
            print("landscape")
            verticalStackView.axis = .horizontal
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
            print("Portrait")
            verticalStackView.axis = .vertical
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(playState: .NotPlaying) // Sets buttons to NotPlaying state
    }
    
    func setupStopButton() {
        
        /* Solution to bug: LayoutSubviews was causing bugs & cornerRadius woulden't work any other way.
         DispatchQueue seemed to be the solution.
         */
        DispatchQueue.main.async {
            // Round edges of button
            self.stopPlaybackButton.layer.cornerRadius = 10
            self.stopPlaybackButton.layer.masksToBounds = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
