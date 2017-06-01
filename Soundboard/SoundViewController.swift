//
//  SoundViewController.swift
//  Soundboard
//
//  Created by Steven Sherry on 12/15/16.
//  Copyright © 2016 Affinity for Apps. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        //disable the play button until sound is recorded
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        do {
            //Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Create URL for the audio file
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            // Create settings for the audio recorder
            
            var settings : [String:Any] = [:]
            settings [AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            
            // Create Audio Recorder object
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording {
            //Stop the recording
            audioRecorder?.stop()
            //Change button title to "Record"
            recordButton.setTitle("Record", for: .normal)
            //enable play button after sound is recorded
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        } else {
            //start recording
            audioRecorder?.record()
            //change button title to stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch let error as NSError {
        print(error)
    }
    }
    @IBAction func addTapped(_ sender: Any) {
        //make sound object
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        sound.name = textField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
}
