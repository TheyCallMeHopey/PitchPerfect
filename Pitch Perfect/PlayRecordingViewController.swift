//
//  PlayRecordingViewController.swift
//  Pitch Perfect
//
//  Created by Hope on 11/2/15.
//  Copyright (c) 2015 Hope Elizabeth. All rights reserved.
//

import UIKit
import AVFoundation

class PlayRecordingViewController: UIViewController
{
    var audioEngine: AVAudioEngine!
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.recordingFilePathURL);
        audioPlayer.enableRate = true;
        audioEngine = AVAudioEngine();
        audioFile = try? AVAudioFile(forReading: receivedAudio.recordingFilePathURL);
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func speed(rate:Float)
    {
        audioPlayer.stop();
        audioPlayer.currentTime = 0;
        audioPlayer.rate = rate;
        audioPlayer.play();
    }
    
    func pitch (thePitch:Float)
    {
        audioPlayer.stop();
        audioEngine.stop();
        audioEngine.reset();
        
        let audioPlayerNode = AVAudioPlayerNode();
        audioEngine.attachNode(audioPlayerNode);
        
        let changePitchEffect = AVAudioUnitTimePitch();
        changePitchEffect.pitch = thePitch;
        audioEngine.attachNode(changePitchEffect);
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil);
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil);
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil);
        try! audioEngine.start();

        audioPlayerNode.play();
    }
    
    @IBAction func snailSpeed(sender: UIButton)
    {
        speed (0.5);
    }

    @IBAction func cheetahSpeed(sender: UIButton)
    {
        speed (2);
    }
    
    @IBAction func chipmunkPitch(sender: UIButton)
    {
        pitch(1100);
    }
    
    @IBAction func darthVaderPitch(sender: UIButton)
    {
        pitch(-1100);
    }
    
    @IBAction func stopButton(sender: UIButton)
    {
        audioPlayer.stop();
        audioEngine.stop();
        audioEngine.reset();
        audioPlayer.currentTime = 0;
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
