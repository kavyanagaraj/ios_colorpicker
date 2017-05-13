//
//  ViewController.swift
//  colorpicker
//
//  Created by Colin Jao on 5/12/17.
//  Copyright © 2017 Colin Jao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer = Timer()
    var counter: Double = 60.0
    
    @IBOutlet weak var colorView: ColorView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        counter = 60.0
        colorView.timer = counter
    }
    
    func updateTimer() {
        if counter > 0 {
            colorView.timer -= 0.0035
//            print(colorView.timer)
            counter -= 0.0035
            timerLabel.text = String(Int(counter))
        } else {
            timer.invalidate()
            let alert = UIAlertController(title: "You lose!", message: "You ran out of time.", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
            self.present(alert, animated: true, completion: nil);
        }
//        print(timer)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        colorView.timer = 60.0
        timerLabel.text = String(Int(counter))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

