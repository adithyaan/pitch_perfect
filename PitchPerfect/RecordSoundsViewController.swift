//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Adithya.A.N on 19/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var startRecording: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    


    @IBAction func recordAudo(_ sender: Any) {
        configureUI(isRecording: false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecording.isEnabled = false
        recordingLabel.text = "Tap to Record"
        stopRecording.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        stopRecording.heightAnchor.constraint(equalToConstant: 23.0).isActive = true
    }
    
    @IBAction func stopRecording(_ sender: Any) {
          configureUI(isRecording: true)

        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        audioRecorder.stop()
    }
    
    
    func configureUI(isRecording: Bool) {
        startRecording.isEnabled = isRecording
        stopRecording.isEnabled = !isRecording
        recordingLabel.text = isRecording ? "Tap to Record" : "Recording in progress"

    }

    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("file not saved")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioUrl = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioUrl
            
        }
    }
}

