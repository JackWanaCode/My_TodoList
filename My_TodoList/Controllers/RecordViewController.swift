//
//  TableViewController.swift
//  My_TodoList
//
//  Created by Aries Lam on 4/1/19.
//  Copyright © 2019 Cuong Tran. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class RecordViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordBTN: UIButton!
    @IBOutlet weak var playBTN: UIButton!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    
    let realm = try! Realm()
    
    var check : Bool?
    
    var fileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed. \(error)")
        }
        if check == true {
            playBTN.isEnabled = true
        } else {
            playBTN.isEnabled = false
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecorder() {
        if fileName != nil {
            let voiceURL = getDocumentsDirectory().appendingPathComponent(fileName!)
            print("setup Recorder \(voiceURL)")
            let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless ,
                                  AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                                  AVEncoderBitRateKey : 320000,
                                  AVNumberOfChannelsKey : 2,
                                  AVSampleRateKey : 44100.2 ] as [String : Any]
            do {
                soundRecorder = try AVAudioRecorder(url: voiceURL, settings: recordSetting)
                soundRecorder.delegate = self
                soundRecorder.prepareToRecord()
            } catch {
                print(error)
            }
        }
    }
    
    func setupPlayer() {
        if fileName != nil {
            let voiceURL = getDocumentsDirectory().appendingPathComponent(fileName!)
            print("setup Player \(voiceURL)")
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: voiceURL)
                soundPlayer.delegate = self
                soundPlayer.prepareToPlay()
                soundPlayer.volume = 10.0
            } catch {
                print(error)
            }
        } else {
            print ("setup Player, no fileName")
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playBTN.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBTN.isEnabled = true
        playBTN.setTitle("Play", for: .normal)
    }
   
    @IBAction func recordAct(_ sender: Any) {
        if recordBTN.titleLabel?.text == "Record" {
            setupRecorder()
            soundRecorder.record()
            recordBTN.setTitle("Stop", for: .normal)
            playBTN.isEnabled = false
        } else {
            soundRecorder.stop()
            recordBTN.setTitle("Record", for: .normal)
            playBTN.isEnabled = false
        }
    }
    
    @IBAction func playAct(_ sender: Any) {
        if playBTN.titleLabel?.text == "Play" {
            playBTN.setTitle("Stop", for: .normal)
            recordBTN.isEnabled = false
            setupPlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            playBTN.setTitle("Play", for: .normal)
            recordBTN.isEnabled = false
        }
    }
    
}
