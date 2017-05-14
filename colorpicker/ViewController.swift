//
//  ViewController.swift
//  colorpicker
//
//  Created by Colin Jao on 5/12/17.
//  Copyright © 2017 Colin Jao. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // Game Variables
    var gameInProgress: Bool = true
    var score: Int = 0
    var round: Int = 0
    var timer = Timer()
//    var colorToMatch: Int
//    var userColor: Int
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // IB Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var colorView: ColorView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet var GameView: UIView!
    
    // IB Actions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startButton.isHidden = true
        readyButton.isHidden = false
        round = 1
        instructionsLabel.isHidden = true
    }
    
    @IBAction func readyButtonPressed(_ sender: UIButton) {
        readyButton.isHidden = true
        let roundTime = 10/Double(round)
        setTimer(time: roundTime)
    }
    
    func setTimer(time: Double) {
        // UPDATETIMER FIRES EVERY MILLISECOND
        timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        colorView.timer = time
        colorView.maxArcLength = time
    }
    
    func updateTimer() {
        
        // IF COLOR IS MATCHED:
        if colorView.timer < 3.0 {
        //      --STOP THE TIMER--
              timer.invalidate()
        //      --INCREMENT ROUND--
              round += 1
              roundLabel.text = "Round: " + String(round)
        //      --INCREMENT SCORE--
              let quartile = colorView.maxArcLength / 4
              if colorView.timer > (quartile * 3) {
                  score += 200
              } else if colorView.timer > (quartile * 2) {
                  score += 150
              } else if colorView.timer > quartile {
                  score += 125
              } else {
                  score += 100
              }
              scoreLabel.text = "Score: " + String(score)
        //      --SHOW READY BUTTON--
              readyButton.isHidden = false
        }
    
        else if colorView.timer > 0 {
            // DECREMENT TIMER
            colorView.timer -= 0.005
            timerLabel.text = String(Int(colorView.timer))
        } else {
            // IF TIMER REACHES ZERO:
            //      ALERT THE USER
            //      SET GAMEINPROGRESS TO FALSE
            timer.invalidate()
            gameInProgress = false
            let alert = UIAlertController(title: "You lose!", message: "You ran out of time.", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = "😎"
        startButton.isHidden = false
        readyButton.isHidden = true
        instructionsLabel.isHidden = false
        scoreLabel.text = "Score: 0"
        roundLabel.text = "Round: 1"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let moc = managedObjectContext
        let colorsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Color")
        
        do {
            var _: [Color]
            let fetchedColors = try moc.fetch(colorsFetch) as! [Color]
            print(fetchedColors.count)
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
    }
    
}

