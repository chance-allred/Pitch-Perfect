//
//  SupportFunctions.swift
//  Pitch Perfect
//
//  Created by Chance Allred on 10/1/16.
//  Copyright © 2016 Chance Allred. All rights reserved.
//

import UIKit
import AudioToolbox

/*Credit to: Aleix Pinardell @ StackOverflow for extension*/
extension SystemSoundID {
    static func playFileNamed(fileName: String, withExtenstion fileExtension: String? = "aif") {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}

func animateButtonPress(button: UIButton) {
    // Animated Button Press. Code Complements: nRewik @ StackOverflow
    UIView.animate(withDuration: 0.2 , animations: {
        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { finish in UIView.animate(withDuration: 0.2){
            button.transform = CGAffineTransform.identity
            }
    })
}
