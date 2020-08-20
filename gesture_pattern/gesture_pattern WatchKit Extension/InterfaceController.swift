//
//  InterfaceController.swift
//  ptDraw WatchKit Extension
//
//  Created by gunuk on 2017. 9. 4..
//  Copyright © 2017년 gunuk. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity
//import HealthKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @IBOutlet var error: WKInterfaceLabel!
    
    let motion = CMMotionManager()
    var session: WCSession!
    var accel_X: String = ""
    var accel_Y: String = ""
    var accel_Z: String = ""
    var gyro_X: String = ""
    var gyro_Y: String = ""
    var gyro_Z: String = ""
    var timer = Timer()
    var flag: Int = 0
    var start: String = ""
    var status: String = ""
    var Index: String = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if(context == nil){
            print("context error")
        }else{
            status = context as! String
            print("\(status)")
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported(){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override init() {
        super.init()
    }
    
    @IBOutlet var startBtn: WKInterfaceButton!
    
    @IBAction func sensingStart() {// 휴대폰으로 애플워치의 상태값과 가속도 값을 서버로 전달.
        if flag == 0{
            startBtn.setTitle("Stop")
            flag = 1
            
            motion.accelerometerUpdateInterval = 0.1
            motion.startAccelerometerUpdates(to: OperationQueue.current!){(accelerometerData:CMAccelerometerData?, NSError) -> Void in
                self.outputAccelerationData(acceleration: accelerometerData!.acceleration)
                if(NSError != nil){
                    self.error.setText("\(NSError)")
                    NSLog("test")
                }
                else{
                    
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    let currentTime = NSDate()
                    let curTime = format.string(from: currentTime as Date)
                    
                    self.start = "5"
                    if WCSession.isSupported(){
                        self.session.sendMessage(["b":"\(self.start)"+"\(self.status)"+","+"\(curTime)"+","+"\(self.accel_X)"+","+"\(self.accel_Y)"+","+"\(self.accel_Z)"], replyHandler: nil, errorHandler: nil)
                        self.error.setText("Sensing")
                        print("\(self.start)"+"\(self.status)"+","+"\(curTime)"+","+"\(self.accel_X)"+","+"\(self.accel_Y)"+","+"\(self.accel_Z)")
                    }
                    
                }
            }
        }
        else{
            startBtn.setTitle("Start")
            flag = 0
            start = "4"
            motion.stopAccelerometerUpdates()
            error.setText("Stop")
        }
    }
    
    func outputAccelerationData(acceleration: CMAcceleration){
        accel_X = String(acceleration.x)
        accel_Y = String(acceleration.y)
        accel_Z = String(acceleration.z)
    }
    
    @IBAction func DisconnectBtn() {
        motion.stopAccelerometerUpdates()
        if WCSession.isSupported(){
            session.sendMessage(["b":"Disconnect"], replyHandler: nil, errorHandler: nil )
        }
        startBtn.setTitle("Start")
        print("disconnect")
        error.setText("Disconnect")
    }
}
