//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by 张子清 on 2018/1/1.
//  Copyright © 2018年 ziqingz. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate{
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var StopRecord: UIButton!
    @IBOutlet weak var Record: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopRecord.isEnabled = false
        Record.isEnabled = true
        Label.text = "Tap to Recording..."
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Stop(_ sender: Any) {
        StopRecord.isEnabled = false
        Record.isEnabled = true
        Label.text = "Tap to Recording..."
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    @IBAction func record(_ sender: Any) {
        Record.isEnabled = false
        StopRecord.isEnabled = true
        Label.text = "Recording in Progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "StopRecording", sender: audioRecorder.url)
        }
        else {
            print("Recording not finished")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StopRecording"{
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
            
        }
    }

}

