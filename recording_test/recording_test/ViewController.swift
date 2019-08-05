//
//  ViewController.swift
//  recording_test
//
//  Created by Jinwon on 01/08/2019.
//  Copyright © 2019 Jinwon. All rights reserved.
//


//https://medium.com/@javedmultani16/ios-filemanager-in-swift-e0854c7dfa60

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var label : UILabel!
    
    var recordingSession : AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
//        let logsPath = documentsPath.appendingPathComponent("data")
//        print(logsPath!)
//        label.text = "\(logsPath)"
//
//        do{
//            try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
//
//        }catch let error as NSError{
//            print("Unable to create directory",error)
//        }
//
//        let file = "file1.txt"
//        let text = "힌글도 잘 읽히려나"
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
//            let fileURL = dir.appendingPathComponent(file)
//            //writing
//
//            do{
//                try text.write(to: fileURL, atomically: false, encoding: .utf8)
//            }catch{
//                print("Can't write…")
//            }
//        }
//
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
//            let file = "file1.txt"
//            let fileURL = dir.appendingPathComponent(file)
//
//            //reading
//
//            do{
//                let text = try String(contentsOf: fileURL, encoding: .utf8)
//                print(text)
//            }catch{
//                print("Can't read…")
//            }
//        }
    }
   
    func startRecording(){
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try! audioSession.setActive(true)
        audioSession.requestRecordPermission({(allowed: Bool) -> Void in print("Accepted")} )
        
        let currentTime = NSDate()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = format.string(from: currentTime as Date)
        let audioFilename = getDocumentsDirectory().appendingPathComponent(time+".wav")
        
        let settings = [
            AVFormatIDKey : Int(kAudioFormatLinearPCM),
            AVSampleRateKey : 44100,
            AVNumberOfChannelsKey : 1,
            AVLinearPCMBitDepthKey : 16,
            AVLinearPCMIsFloatKey : false,
            AVLinearPCMIsBigEndianKey : false,
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
            ] as [String : Any]
        
        do{
            audioRecorder = try AVAudioRecorder(url:audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch{
            finishRecording(success : false)
        }
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for:.documentDirectory, in : .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(success:Bool){
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    @IBAction func recording(_ sender: UIButton){
        startRecording()
    }
    @IBAction func stopRecord(_ sender: UIButton){
        finishRecording(success: true)
    }
    

}

