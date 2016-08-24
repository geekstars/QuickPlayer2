//
//  ViewController.swift
//  QuickPlayer2
//
//  Created by Hoàng Minh Thành on 8/23/16.
//  Copyright © 2016 Hoàng Minh Thành. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController ,AVAudioPlayerDelegate{

    @IBOutlet weak var lbl_timeLeft: UILabel!
    @IBOutlet weak var lbl_timeTotal: UILabel!
    @IBOutlet weak var sliderDuration: UISlider!
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var switch_repeat: UISwitch!
    @IBOutlet weak var zinglogo: UIImageView!
    @IBOutlet weak var btn_play: UIButton!
    var audio = AVAudioPlayer()
    var timer = NSTimer()
    override func viewDidLoad() {
        super.viewDidLoad()
        audio = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("music", ofType: ".mp3")!))
        audio.prepareToPlay()
        sliderDuration.minimumValue = 0.0
        sliderDuration.maximumValue = Float(UInt32(audio.duration))
        audio.delegate = self
    }
    var rotate:Float = 0
    func updateTimeLeft()
    {
        if state == true {
            rotate = Float(rotate + 10)
            zinglogo.transform = CGAffineTransformMakeRotation(CGFloat(rotate))
        }
        var minute:UInt32 = 0
        var second:UInt32 = 0
        if UInt32(audio.currentTime/60) > 0
        {
            minute = UInt32(audio.currentTime/60)
            second = UInt32(audio.currentTime%60)
        }
        else
        {
            minute = 0
            second = UInt32(audio.currentTime%60)        }
        if minute < 10
        {
            if second < 10
            {
                lbl_timeLeft.text = "0\(String(minute)):0\(String(second))"
            }
            else
            {
                lbl_timeLeft.text = "0\(String(minute)):\(String(second))"
            }
        }
        else
        {
            lbl_timeLeft.text = "\(String(minute)):\(String(second))"
        }
        sliderDuration.value = Float(UInt32(audio.currentTime))
        if switch_repeat.on == true {
            audio.numberOfLoops = -1
        }
        else {
            audio.numberOfLoops = 0
        }
    }
    var state:Bool = false
    @IBAction func btn_play(sender: UIButton) {
        let minute = UInt32(audio.duration/60)
        let second = UInt32(audio.duration%60)
        if state == false
        {
            audio.play()
            btn_play.setBackgroundImage(UIImage(named: "pause.png"), forState: .Normal)
            state = true
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTimeLeft), userInfo: nil, repeats: true)
            if minute < 10
            {
                lbl_timeTotal.text = "0\(String(minute)):\(String(second))"
            }
            else
            {
                lbl_timeTotal.text = "\(String(minute)):\(String(second))"
            }
        }
        else
        {
            audio.pause()
            btn_play.setBackgroundImage(UIImage(named: "play.png"), forState: .Normal)
            state = false
        }
    }

    @IBAction func slider_duration(sender: UISlider) {
        sliderDuration.value = sender.value;
        let minute = UInt32(sender.value/60)
        let second = UInt32(sender.value%60)
        let minutes = UInt32(audio.duration/60)
        let seconds = UInt32(audio.duration%60)
        if minute < 10
        {
            lbl_timeLeft.text = "0\(String(minute)):\(String(second))"
            lbl_timeTotal.text = "0\(String(minutes)):\(String(seconds))"
        }
        else
        {
            lbl_timeLeft.text = "\(String(minute)):\(String(second))"
            lbl_timeTotal.text = "\(String(minutes)):\(String(seconds))"
        }
        if state == true {
            audio.stop()
            sliderDuration.value = sender.value
            audio.currentTime = Double(sender.value)
            audio.play()
        }
        else
        {
            sliderDuration.value = sender.value
            audio.currentTime = Double(sender.value)
        }
    }
    @IBAction func volumeSlider(sender: UISlider) {
        audio.volume = sender.value
    }
    @IBAction func action_repeat(sender: UISwitch) {
        if switch_repeat.on == true {
            audio.numberOfLoops = -1
        }
        else {
            audio.numberOfLoops = 0
        }
    }
    func audioPlayerDidFinishPlaying(player:AVAudioPlayer,successfully flag:Bool) {
        if switch_repeat.on == false {
            btn_play.setBackgroundImage(UIImage(named: "play.png"), forState: .Normal)
            state = false
        }
    }
}

