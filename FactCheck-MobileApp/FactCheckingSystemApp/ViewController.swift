//
//  ViewController.swift
//  FactCheckingSystemApp
//
//  Created by Sukhamrit Singh on 8/3/21.
//

import UIKit
import Speech
import NVActivityIndicatorView

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var buttonBgView: UILabel!
    @IBOutlet weak var errMsgLabel: UILabel!
    
    @IBOutlet weak var inputLbl: UILabel!
    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    //var activityView: NVActivityIndicatorView? = nil
    @IBOutlet weak var activityIndicator2: NVActivityIndicatorView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buttonBgView.backgroundColor = .white
        buttonBgView.layer.cornerRadius = 125
        buttonBgView.layer.borderColor = UIColor.gray.cgColor
        buttonBgView.layer.borderWidth = 3
        buttonBgView.layer.masksToBounds = true
        buttonBgView.text = ""
        
        self.microphoneButton.backgroundColor = .systemBlue
        
        inputTextView.layer.cornerRadius = 10
        inputTextView.layer.borderColor = UIColor.gray.cgColor
        inputTextView.layer.borderWidth = 0.75
        
        inputLbl.layer.cornerRadius = 10
        inputLbl.layer.borderColor = UIColor.gray.cgColor
        inputLbl.layer.borderWidth = 0.75
        inputLbl.textAlignment = .center
        inputLbl.numberOfLines = 0
        
        activityIndicator.type = .lineScalePulseOut
        activityIndicator.color = .red
    
        activityIndicator2.type = .ballPulse
        activityIndicator2.color = .systemBlue
        
        activityIndicator.isHidden = false
        activityIndicator2.isHidden = true
        
        setUpMic()
    }
    
    func setUpMic() {
        super.viewDidLoad()
        
        microphoneButton.isEnabled = false  //2
        
        speechRecognizer.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
                
            @unknown default:
                fatalError()
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    
    @IBAction func handleFactCheck(_ sender: Any) {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false

            UIView.animate(withDuration: 0.15, animations: {
                self.microphoneButton.transform = CGAffineTransform(scaleX: 1,y: 1)
                    self.microphoneButton.layer.cornerRadius = 125
                    self.microphoneButton.backgroundColor = .systemBlue
                }
            )
            activityIndicator.isHidden = true
            activityIndicator2.isHidden = false
            
            activityIndicator.stopAnimating()
            //activityIndicator2.startAnimating()
            self.callFactCheck()
            
        } else {
            inputLbl.text = ""
            errMsgLabel.text = ""
            startRecording()
            //microphoneButton.setTitle("Stop Recording", for: .normal)
            microphoneButton.center = buttonBgView.center
            UIView.animate(withDuration: 0.15, animations: {

                self.microphoneButton.transform = CGAffineTransform(scaleX: 0.65,y: 0.65)
                    self.microphoneButton.layer.cornerRadius = 20
                    self.microphoneButton.backgroundColor = .red
                }
            )

            activityIndicator.isHidden = false
            activityIndicator2.isHidden = true
            activityIndicator.startAnimating()
            activityIndicator2.stopAnimating()
        }
        
    }
    
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        let inputNode = audioEngine.inputNode
        
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                
                self.inputTextView.text = result?.bestTranscription.formattedString  //9
                self.inputLbl.text = self.inputTextView.text
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //inputLbl.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }

    func callFactCheck() {
    
        let text = inputTextView.text
        let wordCount = text?.split(separator: " ")
        
        if (wordCount!.count < 5 ) {
            errMsgLabel.textColor = .red
            errMsgLabel.text = "Claim too short to be fact checked."
            return
        }
        
        //
        errMsgLabel.textColor = .green
//        errMsgLabel.text = "will fact check now :)"
        
        self.activityIndicator2.startAnimating()
        
        let delayInSeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.activityIndicator2.stopAnimating()
            self.showFactCheckResults()
        }
        
    }
    
    func showFactCheckResults() {
        performSegue(withIdentifier: "showResultSegue", sender: nil)
    }
}

