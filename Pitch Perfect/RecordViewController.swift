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
        recordingButton.hidden = false;
    }
    
    @IBAction func recordAudio(sender: UIButton)
    {
        onAirLabel.hidden = false;
        stopButton.hidden = false;
        
        //Set the path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] ;
        //Name the recording
        let recordingName = "recorded_audio.wav";
        let pathArray = [dirPath, recordingName];
        let filePath = NSURL.fileURLWithPathComponents(pathArray);
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0]
        print(filePath);
        //Prep the recording session
        let session = AVAudioSession.sharedInstance();
        do
        {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            audioRecorder = try AVAudioRecorder(URL: filePath!, settings: recordSettings as! [String : AnyObject])
        }
        catch _
        {
            print("Error");
        };
        //TO DO: What is wrong here?
        //audioRecorder try! = AVAudioRecorder(URL: filePath!, settings: nil);

        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true;
        //Ready to record and starts recording
        audioRecorder.prepareToRecord();
        audioRecorder.record();
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
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
            print("Recording was not successful");
            recordingButton.enabled = true;
            stopButton.hidden = true;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "stopRecording")
        {
            let playRecordingVC: PlayRecordingViewController = segue.destinationViewController as! PlayRecordingViewController;
            let data = sender as! RecordedAudio;
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
        let audioSession = AVAudioSession.sharedInstance();
        do {
            try audioSession.setActive(false)
        } catch _ {
        };
    }
}