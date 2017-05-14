//
//  ViewController.swift
//  colorpicker
//
//  Created by Colin Jao on 5/12/17.
//  Copyright © 2017 Colin Jao. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    //############
    //GAME SECTION
    //############
    

    // Game Variables
    var motionManager: CMMotionManager?
    var detectShake = false
    var gameInProgress: Bool = true
    var score: Int = 0
    var roundScore: Int = 0
    var gameRound: Int = 0
    var timer = Timer()
    var matched = false
    var randColor = (1,1,1)
    var contrast = (0,0,0)
    var roundInProgress: Bool = false
    let colorArr = [(5, 0, 5), (5, 0, 4), (6, 0, 4), (6, 0, 3), (6, 1, 3), (6, 1, 2), (5, 1, 2), (6, 2, 2), (6, 2, 1), (6, 3, 1), (6, 3, 0), (7, 3, 1), (7, 2, 1), (7, 2, 2), (7, 1, 2), (7, 1, 3), (5, 0, 3), (4, 0, 3), (4, 1, 3), (4, 1, 2), (4, 2, 1), (4, 3, 1), (4, 3, 0), (4, 4, 0), (5, 4, 0), (5, 5, 0), (6, 5, 0), (6, 6, 0), (7, 6, 0), (7, 6, 1), (8, 6, 1), (8, 7, 1), (8, 7, 2), (8, 8, 2), (8, 8, 3), (8, 9, 3), (7, 9, 3), (7, 10, 4), (6, 10, 4), (6, 10, 5), (5, 10, 5), (5, 10, 6), (4, 10, 6), (3, 10, 6), (3, 9, 6), (3, 9, 7), (2, 9, 7), (2, 8, 6), (1, 8, 6), (1, 7, 6), (0, 7, 6), (0, 7, 5), (0, 6, 5), (0, 6, 4), (0, 6, 3), (0, 5, 3), (1, 5, 3), (1, 5, 2), (1, 4, 2), (2, 4, 1), (3, 4, 1), (3, 3, 1), (5, 2, 1), (5, 1, 3)]
    
    
//    var colorToMatch: Int
//    var userColor: Int

    // IB Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var colorView: ColorView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var shakeLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var roundScoreLabel: UILabel!
    
    // IB Actions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startButton.isHidden = true
        detectShake = true
        shakeLabel.isHidden = true
        gameRound = 1
        score = 0
        instructionsLabel.isHidden = true
        scoreLabel.text = "Score: 0"
        roundLabel.text = "Round: 1"
        roundScoreLabel.isHidden = true
    }
    
    func setTimer(time: Double) {
        // UPDATETIMER FIRES EVERY MILLISECOND
        if !roundInProgress {
        timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        colorView.timer = time
        colorView.maxArcLength = time
        }
    }
    
    func updateTimer() {
        
    
        if colorView.timer > 0 {
            // DECREMENT TIMER
            colorView.timer -= 0.005
            timerLabel.text = String(Int(colorView.timer))
            roundScore = Int(1000 * (colorView.timer/colorView.maxArcLength))
            roundScoreLabel.text = "\(roundScore)"
        } else {
            // IF TIMER REACHES ZERO:
            //      ALERT THE USER
            //      SET GAMEINPROGRESS TO FALSE
            timer.invalidate()
            gameInProgress = false
            roundInProgress = false
            startButton.isHidden = false
            detectShake = false
            roundScoreLabel.isHidden = true
            instructionsLabel.isHidden = false
            let alert = UIAlertController(title: "You lose!", message: "You ran out of time.", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = "😎"
        startButton.isHidden = false
        detectShake = false
        instructionsLabel.isHidden = false
        scoreLabel.text = "Score: 0"
        roundLabel.text = "Round: 1"
        roundScoreLabel.isHidden = true
        shakeLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //###################
    //User Motion Section
    //###################
    
    override func viewDidAppear(_ animated: Bool) {
//        print(Double((randColor.0))/10)
        motionManager = CMMotionManager()
        if let manager = motionManager {
            
            if manager.isDeviceMotionAvailable {
                manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
                    (data: CMDeviceMotion?, error: Error?) in
                    if let mydata = data {
                        
                        let xcolors = round((mydata.gravity.x + 1)*5)
                        let zcolors = round((mydata.gravity.z + 1)*5)
                        let ycolors = round((mydata.gravity.y + 1)*5)
                        
                        // IF COLOR IS MATCHED:
                        if  abs(Int(xcolors)-self.randColor.0) < 1 && abs(Int(zcolors)-self.randColor.1) < 1 &&
                            abs(Int(ycolors)-self.randColor.2) < 1 {
                            //      --STOP THE TIMER--
                            self.timer.invalidate()
                            //      --INCREMENT ROUND--
                            if self.roundInProgress {
                                self.roundInProgress = false
                                self.gameRound += 1
                                self.roundLabel.text = "Round: " + String(self.gameRound)
                            //      --INCREMENT SCORE--
//                                let quartile = self.colorView.maxArcLength / 4
//                                if self.colorView.timer > (quartile * 3) {
//                                    self.score += 200
//                                } else if self.colorView.timer > (quartile * 2) {
//                                    self.score += 150
//                                } else if self.colorView.timer > quartile {
//                                    self.score += 125
//                                } else {
//                                    self.score += 100
//                                }
                                self.score += self.roundScore
                                self.scoreLabel.text = "Score: \(self.score)"
                            //      --SHOW READY BUTTON--
                                self.detectShake = true
                                self.shakeLabel.isHidden = false
                                self.matched = true
                            }
                        }
                        
                        if self.detectShake && ((mydata.userAcceleration.x > 2 || mydata.userAcceleration.x < -2) || (mydata.userAcceleration.y > 2 || mydata.userAcceleration.y < -2) || (mydata.userAcceleration.z > 2 || mydata.userAcceleration.z < -2)) {
                            let roundTime = 60/Double(self.gameRound)
                            self.setTimer(time: roundTime)
                            self.randColor = self.colorArr[Int(arc4random_uniform(UInt32(self.colorArr.count)))]
                            self.colorView.timerColor = UIColor(red: CGFloat(Double((self.randColor.0))/10), green: CGFloat(Double((self.randColor.1))/10), blue: CGFloat(Double((self.randColor.2))/10), alpha: 1)
                            self.matched = false
                            self.roundInProgress = true
                            self.contrast = self.contrastTupe(tupe: self.randColor)
                            self.colorView.outlineColor = UIColor(red: CGFloat(Double((self.contrast.0))/10), green: CGFloat(Double((self.contrast.1))/10), blue: CGFloat(Double((self.contrast.2))/10), alpha: 1)
                            self.roundScore = 1000
                            self.roundScoreLabel.text = "\(self.roundScore)"
                            self.roundScoreLabel.isHidden = false
                            self.detectShake = false
                        }
                        
                        if self.matched == true {
                            self.contrast = self.contrastTupe(tupe: (self.randColor))
                           self.view.backgroundColor = UIColor(red: CGFloat(Double((self.randColor.0))/10), green: CGFloat(Double((self.randColor.1))/10), blue: CGFloat(Double((self.randColor.2))/10), alpha: 1)
                            self.colorView.backgroundColor = UIColor(red: CGFloat(Double((self.randColor.0))/10), green: CGFloat(Double((self.randColor.1))/10), blue: CGFloat(Double((self.randColor.2))/10), alpha: 1)
                            self.timerLabel.textColor = UIColor(red: CGFloat(Double((self.contrast.0))/10), green: CGFloat(Double((self.contrast.1))/10), blue: CGFloat(Double((self.contrast.2))/10), alpha: 1)
                        }
                        else {
                            self.contrast = self.contrastTupe(tupe: (Int(xcolors),Int(zcolors),Int(ycolors)))
                        self.view.backgroundColor = UIColor(red: CGFloat(xcolors/10), green: CGFloat(zcolors/10), blue: CGFloat(ycolors/10), alpha: 1)
                        self.colorView.backgroundColor = UIColor(red: CGFloat(xcolors/10), green: CGFloat(zcolors/10), blue: CGFloat(ycolors/10), alpha: 1)
                        self.timerLabel.textColor = UIColor(red: CGFloat(Double((self.contrast.0))/10), green: CGFloat(Double((self.contrast.1))/10), blue: CGFloat(Double((self.contrast.2))/10), alpha: 1)
                        }
                        
                        
                        
//                        self.rgb.text = "X: \(randColor.0) Y: \(randColor.1) Z: \(randColor.2)"
//                        self.rgb.textColor = UIColor(red: CGFloat(Double((randColor.0))/10), green: CGFloat(Double((randColor.1))/10), blue: CGFloat(Double((randColor.2))/10), alpha: 1)
                    }
                    if let myerror = error {
                        print("myerror", myerror)
                        manager.stopDeviceMotionUpdates()
                    }
                })
            }
            else {
                print("no motion")
            }
        }
        else {
            print("No motion manager")
        }
    }
    func contrastTupe(tupe: (Int,Int,Int)) -> (Int,Int,Int) {
        let tupArr = [tupe.0,tupe.1,tupe.2]
        var max = tupe.0
        var min = tupe.0
        var total = 0
        for i in tupArr {
            if i > max {
                max = i
            }
            if i < min {
                min = i
            }
        }
        total = max + min
        return (total-tupe.0,total-tupe.1,total-tupe.2)
        
    }
}

