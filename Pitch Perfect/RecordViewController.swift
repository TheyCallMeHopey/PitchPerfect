//
//  RecordViewController.swift
//  Pitch Perfect
//
//  Created by Hope on 10/29/15.
//  Copyright (c) 2015 Hope Elizabeth. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate
{
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var onAirLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        onAirLabel.hidden = true;
        stopButton.hidden = true;
    }
    
    @IBAction func recordAudio(sender: UIButton)
    {
        onAirLabel.hidden = false;
        stopButton.hidden = false;
        
        //Set the path
        var dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String;
        //Name the recording
        let recordingName = "recorded_audio.wav";
        let pathArray = [dirPath, recordingName];
        let filePath = NSURL.fileURLWithPathComponents(pathArray);
        println(filePath);
        //Prep the recording session
        var session = AVAudioSession.sharedInstance();
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil);
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil);
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true;
        //Ready to record and starts recording
        audioRecorder.prepareToRecord();
        audioRecorder.record();
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if(flag)
        {
            recordedAudio = RecordedAudio();
            recordedAudio.recordingFilePathURL = recorder.url;
            recordedAudio.title = recorder.url.lastPathComponent;
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio);
        }
        else
        {
            println("Recording was not successful");
            recordingButton.enabled = true;
            stopButton.hidden = true;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "stopRecording")
        {
            var playRecordingVC: PlayRecordingViewController = segue.destinationViewController as! PlayRecordingViewController;
            var data = sender as! RecordedAudio;
            playRecordingVC.receivedAudio = data;
        }
    }

    @IBAction func stopRecording(sender: UIButton)
    {
        onAirLabel.hidden = true;
        stopButton.hidden = true;
        recordingButton.hidden = true;
        
        audioRecorder.stop();
        
        //Deactivate the audio session - the audio session is now over
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil);
    }
}