//
//  sensorInterfaceController.swift
//  ptDraw
//
//  Created by gunuk on 2017. 9. 4..
//  Copyright © 2017년 gunuk. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion
import HealthKit


class PTsensorInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    var session: WCSession!
    let motion = CMMotionManager()
    
    override func awake(withContext context: Any?) {
        
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
    // 애플워치 버튼 event 발생 함수들
    @IBAction func pt1() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "1")
    }
    
    @IBAction func pt2() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "2")
    }
    
    @IBAction func pt3() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "3")
    }
    
    @IBAction func pt4() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "4")
    }
    
    @IBAction func pt5() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "5")
    }
    
    @IBAction func pt6() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "6")
    }
    
    @IBAction func pt7() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "7")
    }
    
    @IBAction func pt8() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "8")
    }
    
    @IBAction func pt9() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "9")
    }
    
    @IBAction func pt10() {
        if WCSession.isSupported(){
            session.sendMessage(["b":"Connect"], replyHandler: nil, errorHandler: nil)
            print("connect")
        }
        
        pushController(withName: "PTsensing", context: "a")
        
    }
}
