//
//  ResultsViewController.swift
//  FactCheckingSystemApp
//
//  Created by Sukhamrit Singh on 8/3/21.
//

import UIKit
import Speech

class ResultsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var speakBtn: UIBarButtonItem!
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 20.0
    
        scrollView.layer.cornerRadius = 10
        scrollView.layer.borderWidth = 2
        scrollView.layer.borderColor = UIColor.systemGray.cgColor
        
        title1.layer.cornerRadius = 7
        title1.layer.masksToBounds = true
        title2.layer.cornerRadius = 7
        title2.layer.masksToBounds = true
        title3.layer.cornerRadius = 7
        title3.layer.masksToBounds = true

    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func playAudioAction(_ sender: Any) {
        
//        do {
//            let _ = try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .defaultToSpeaker)
//        } catch{
//            print(error)
//        }
        self.setSessionPlayerOn()
        self.prepareAudio()
    }
    
    func setSessionPlayerOn() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            } catch _ {
            }
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch _ {

            }
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
            } catch _ {

            }
        }
    
    func prepareAudio() {
        
        let msg = "Your claim accuracy is 80 percent. This claim is invalid. Corrected claim is... President Obama is the 44th President of the United States"
        
        self.playAudio(msg: msg)
    }
    
    func playAudio(msg: String) {
        
        // Line 1. Create an instance of AVSpeechSynthesizer.
        var speechSynthesizer = AVSpeechSynthesizer()
        // Line 2. Create an instance of AVSpeechUtterance and pass in a String to be spoken.
        var speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: msg)
        
        
        //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        // Line 5. Pass in the urrerance to the synthesizer to actually speak.
        speechSynthesizer.speak(speechUtterance)
        
    }
}
