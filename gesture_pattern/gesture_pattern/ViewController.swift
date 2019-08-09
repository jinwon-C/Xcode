//
//  ViewController.swift
//  ptDraw
//
//  Created by gunuk on 2017. 9. 4..
//  Copyright © 2017년 gunuk. All rights reserved.
//

import UIKit
import SwiftSocket
import CoreMotion
import WatchConnectivity
import HealthKit
import AVFoundation

class ViewController: UIViewController, WCSessionDelegate, AVAudioRecorderDelegate {
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print ("error in sessionDidBecomeInactive")
    }
    public func sessionDidDeactivate(_ session: WCSession) {
        print ("error in SesssionDidDeactivate")
    }
    public func session(_ session: WCSession, activationDidCompleteWith    activationState: WCSessionActivationState, error: Error?) {
        print ("error in activationDidCompleteWith error")
    }
    
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var X_1: UILabel!
    @IBOutlet weak var Y_1: UILabel!
    @IBOutlet weak var Z_1: UILabel!
    @IBOutlet weak var X_2: UILabel!
    @IBOutlet weak var Y_2: UILabel!
    @IBOutlet weak var Z_2: UILabel!
    @IBOutlet weak var connect_btn: UIButton!
    @IBOutlet weak var start_btn: UIButton!
    @IBOutlet weak var btnFreqPlay: UIButton!
    @IBOutlet weak var btnFreqStop: UIButton!
    @IBOutlet weak var btnRecordStart: UIButton!
    @IBOutlet weak var btnRecordFinish: UIButton!
    
    
    var motion = CMMotionManager()
    let host = "192.168.0.137"
    let port = 30330
    let freq: Double = 20000    //hertz
    var client: TCPClient?
    var num:Int = 1
    var flag : Int = 0  //connect 버튼 flag
    var flag1 : Int = 0 //start 버튼 flag
    var timer = Timer()
    var session: WCSession!
    var data: String = ""   // watch에서 받은 데이터 문자열 전체
    var data1: String = ""  // watch에서 받은 데이터 문자열 정리
    var signal: String = ""  // start signal 확인
    var Index: String = ""  // Index 구별
    var Index3: String = "" // Index 구별
    
    var engine : AVAudioEngine!
    var tone : AVTonePlayerUnit!

    var recordingSession : AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    let audioSession = AVAudioSession.sharedInstance()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnFreqStop.isEnabled = false
        btnRecordFinish.isEnabled = false

        client = TCPClient(address: host, port: Int32(port))
        
        tone = AVTonePlayerUnit()
        try! audioSession.setCategory(AVAudioSession.Category.multiRoute)
        try! audioSession.setActive(true)
        tone.frequency = freq
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        print(format?.sampleRate ?? "format nil")
        engine = AVAudioEngine()
        engine.attach(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to:mixer, format : format)
        do{
            try engine.start()
        } catch let error as NSError{
            print(error)
        }
    }
    
    private func sendRequest(string: String, using client: TCPClient) -> String? {
        appendToTextField(string: "Sending data ...")
        
        switch client.send(string: string) {
        case .success:
            appendToTextField(string: "Success")
            return nil
        case .failure(let error):
            appendToTextField(string: String(describing: error))
            return nil
        }
    }
    
    private func appendToTextField(string: String) {
        print(string)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {//init
//        motion.accelerometerUpdateInterval = 0.1
//        motion.gyroUpdateInterval = 0.1
//        motion.startAccelerometerUpdates(to: OperationQueue.current!){(accelerometerData: CMAccelerometerData?, NSError) -> Void in
//            self.outputAccelerationData(acceleration: accelerometerData!.acceleration)
//            if(NSError != nil){
//                print("\(String(describing: NSError))")
//            }
//
//        }
//        motion.startGyroUpdates(to: OperationQueue.current!,withHandler: { (gyroData:CMGyroData?, NSError) -> Void in
//            self.outputGyroData(rotation: gyroData!.rotationRate)
//            if(NSError != nil){
//                print("\(String(describing: NSError))")
//            }
//        })
        
        if WCSession.isSupported(){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    func outputAccelerationData(acceleration: CMAcceleration){
        X_2.text = "\(acceleration.x)"
        Y_2.text = "\(acceleration.y)"
        Z_2.text = "\(acceleration.z)"
    }
    func outputGyroData(rotation:CMRotationRate){
        X_1.text = "\(rotation.x)"
        Y_1.text = "\(rotation.y)"
        Z_1.text = "\(rotation.z)"
    }
    //watch에서 아이폰으로 받은 데이터
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        data = (message["b"]! as? String)!  //51,o or connect
        data1 = "\(data.substring(from: data.index(data.startIndex, offsetBy: 1)))" //1,o
        signal = "\(data.substring(to: data.index(after: data.startIndex)))" //5
        
        Index = "\(data1.substring(to: data1.index(after: data1.startIndex)))" //1
        Index3 = "\(data.substring(from: data.index(data.startIndex, offsetBy: 3)))"    // o
        
        if data == "Connect"{
            flag = 0
            connect_btn.setTitle("Disconncet", for: .normal)
            server_connect()
            
        }
            
        else if data == "Disconnect"{
            flag = 1
            connect_btn.setTitle("Connect", for: .normal)
            server_connect()
        }
        
        if signal == "5"{
            
//            sendRequest(string: Index+","+Index3+","+X_1.text!+","+Y_1.text!+","+Z_1.text!+","+X_2.text!+","+Y_2.text!+","+Z_2.text!+"\n", using: client!)

            sendRequest(string: Index+","+Index3+","+"\n", using: client!)
        }
    }
    
    //아이폰 버튼
    @IBAction func btnconnect(_ sender: UIButton) {
        if flag == 0 {
            btn_Name()
            server_connect()
            startRecording()
        }
        else{
            btn_Name()
            server_connect()
            finishRecording(success: true)
        }
    }
    
    @IBAction func btn_play(_ sender : UIButton){
        toneGenerate()
    }
    
    @IBAction func btn_stop(_ sender : UIButton){
        toneGenerate()
    }
    
    @IBAction func btn_REC(_ sender : UIButton){
        startRecording()
    }
    
    @IBAction func btn_finish(_ sender : UIButton){
        finishRecording(success: true)
    }
    
    @IBAction func btnsend(_ sender: UIButton) {
        if flag1 == 0{
            btn_Name1()
            timerStart()
        }
        else if flag1 == 1{
            btn_Name1()
            timerStart()
        }
    }
    
    func btn_Name1(){
        if flag1 == 0{
            start_btn.setTitle("Stop", for: .normal)
        }
        else{
            start_btn.setTitle("Start", for: .normal)
        }
    }
    
    func timerStart(){
        if flag1 == 0{
            timer = Timer.scheduledTimer(timeInterval: 0.1,target: self,selector: Selector("activeTimer"),userInfo: nil, repeats: true)
            flag1 = 1
        }
        else{
            timer.invalidate()
            flag1 = 0
        }
    }
    
    func btn_Name(){
        if flag == 0{
            connect_btn.setTitle("Disconnect", for: .normal)
        }
        else{
            connect_btn.setTitle("Connect", for: .normal)
        }
    }
    
    func server_connect(){
        if flag == 0{
            print("flag")
            guard let client = client else {return}
            
            switch client.connect(timeout:1000){
            case .success:
                appendToTextField(string: "Connected to host \(client.address)")
                
            case .failure(let error):
                appendToTextField(string: String(describing: error))
            }
            flag = 1
            
        }
        else if flag == 1{
            client?.close()
            flag = 0
        }
        return
    }
    
//    func activeTimer(){
//        //순서 : 식별자, watch 가속도 x,y,z, iPhone 자이로 x,y,z, iPhone 가속도 x,y,z
//        //sendRequest(string: Index+","+data1+","+X_1.text!+","+Y_1.text!+","+Z_1.text!+","+X_2.text!+","+Y_2.text!+","+Z_2.text!+"\n", using: client!)
//        sendRequest(string: Index+","+data1+","+"\n", using: client!)
//    }
    
    func toneGenerate(){
        if tone.isPlaying{
            engine.mainMixerNode.volume = 0.0
            tone.stop()
            engine.reset()
            
            btnFreqPlay.isEnabled = true
            btnFreqStop.isEnabled = false
            btnFreqPlay.setTitle("Play", for: .normal)
        }
        else {
            btnFreqPlay.isEnabled = false
            btnFreqStop.isEnabled = true
            btnFreqPlay.setTitle("Now Playing", for: .normal)
            
            tone.preparePlaying()
            tone.play()
            engine.mainMixerNode.volume = 1.0
        }
    }
    
    func startRecording(){
        audioSession.requestRecordPermission({(allowed: Bool) -> Void in print("Accepted")} )
        //make directory
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent(timeStamp()+".wav")
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
            btnRecordFinish.isEnabled = true
            btnRecordStart.isEnabled = false
            btnRecordStart.setTitle("Now Recording", for: .normal)
            
            audioRecorder = try AVAudioRecorder(url:audioFilename, settings: settings)
            audioRecorder.delegate = self
            print("Recording Start : "+timeStamp())
            audioRecorder.record()
        } catch{
            finishRecording(success : false)
        }
    }
    
    func getDocumentsDirectory() -> URL{    //녹음 파일 경로 설정 함수
//        let paths = FileManager.default.urls(for:.documentDirectory, in : .userDomainMask)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
        let path = FileManager.default.urls(for:.documentDirectory, in : .userDomainMask).first
        let filePath = path?.appendingPathComponent("\(Index)")
        print(filePath)
        if !FileManager.default.fileExists(atPath: filePath!.path){
            do{
                try FileManager.default.createDirectory(atPath: filePath!.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch{
                print("failed to make directory")
            }
        }
        return filePath!
    }
    
    func finishRecording(success:Bool){
        audioRecorder.stop()
        audioRecorder = nil
        print("Recording Finish : "+timeStamp())
        
        btnRecordStart.isEnabled = true
        btnRecordFinish.isEnabled = false
        btnRecordStart.setTitle("REC", for: .normal)
    }
    
    func timeStamp() -> String{
        let currentTime = NSDate()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let time = format.string(from: currentTime as Date)
        return time
    }
}

