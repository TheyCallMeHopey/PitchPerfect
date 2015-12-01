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

        do
        {
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.recordingFilePathURL);
            audioPlayer.enableRate = true;
            audioEngine = AVAudioEngine();
            
            do
            {
                audioFile = try AVAudioFile(forReading: receivedAudio.recordingFilePathURL);
            }
            catch
            {
                
            }
        }
        catch let error as NSError
        {
            print("\(error.localizedDescription)");
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func stopAudio()
    {
        audioEngine.stop();
        audioEngine.reset();
        audioPlayer.stop();
        audioPlayer.currentTime = 0;
    }
    
    func speed(rate:Float)
    {
        stopAudio();
        audioPlayer.rate = rate;
        audioPlayer.play();
    }
    
    func pitch (thePitch:Float)
    {
        stopAudio();
        
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
        stopAudio();
    }
}
