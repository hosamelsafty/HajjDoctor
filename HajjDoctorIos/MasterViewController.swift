//
//  MasterViewController.swift
//  HajjDoctorIos
//
//  Created by Hosam Elsafty on 8/1/18.
//  Copyright © 2018 Hosam Elsafty. All rights reserved.
//

import UIKit
import Speech
import RecordButton


class MainViewController: UIViewController,SFSpeechRecognizerDelegate {
    
    
    @IBOutlet weak var logo: UIImageView!{
        didSet{
            logo.image = UIImage(named: "AppIcon")
        }
    }
    
    @IBOutlet weak var recordView: UIView!
    var recordButton : RecordButton!
    var progressTimer : Timer!
    var progress : CGFloat! = 0
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer : SFSpeechRecognizer? =  SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var node : AVAudioInputNode?
    @IBOutlet weak var input: UITextView!
    var isAppending = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeSpeech()
        
        // set up recorder button
        recordButton = RecordButton(frame: CGRect(x: 0,y: 0,width: 70,height: 70))
//        recordButton.progressColor = .red
        recordButton.closeWhenFinished = false
        recordButton.addTarget(self, action: #selector(MainViewController.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(MainViewController.stop), for: UIControlEvents.touchUpInside)
        recordView.addSubview(recordButton)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAppending = false
    }
    
    @objc func record() {
//        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(MasterViewController.updateProgress), userInfo: nil, repeats: true)
        recordAndRecognizeSpeech()
    }
    
    @objc func updateProgress() {
        let maxDuration = CGFloat(5) // Max duration of the recordButton
        
        progress = progress + (CGFloat(0.05) / maxDuration)
        recordButton.setProgress(progress)
        
        if progress >= 1 {
            progressTimer.invalidate()
        }
        
    }
    
    @objc func stop() {
        isAppending = true
//        self.progressTimer.invalidate()
        stopRecording()
    }
    
    private func authorizeSpeech(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // The callback may not be called on the main thread. Add an
            // operation to the main queue to update the record button's state.
            OperationQueue.main.addOperation {
                var alertTitle = ""
                var alertMsg = ""
                
                switch authStatus {
                case .authorized:
                    print("authorized")
                case .denied:
                    alertTitle = "Speech recognizer not allowed"
                    alertMsg = "You enable the recgnizer in Settings"
                    
                case .restricted, .notDetermined:
                    alertTitle = "Could not start the speech recognizer"
                    alertMsg = "Check your internect connection and try again"
                    
                }
                if alertTitle != "" {
                    let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
//    @IBAction func startRecording(_ sender: UIButton) {
//        if !audioEngine.isRunning{
//            recordAndRecognizeSpeech()
//        }else{
//            stopRecording()
//        }
//    }
    
    private func recordAndRecognizeSpeech(){
        let newNode = audioEngine.inputNode
        node = newNode
        let recordingformat = newNode.outputFormat(forBus:0)
        newNode.installTap(onBus:0, bufferSize: 1024, format: recordingformat){buffer,_ in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {return}
        if !myRecognizer.isAvailable {
            return
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {return}
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: {result,error in
            if let result = result {
                print(result.bestTranscription.formattedString+"\(result.isFinal)")
                if self.isAppending {
                    self.input.text.append(result.bestTranscription.formattedString)
                }else {
                    self.input.text = result.bestTranscription.formattedString
                }
//                if error != nil || result.isFinal {
//                    self.stopRecording()
//                }
            }
        })
    }
    
    @objc func timerEnded() {
        // If the audio recording engine is running stop it and remove the SFSpeechRecognitionTask
        if audioEngine.isRunning {
            stopRecording()
        }
    }
    
    private func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        // Cancel the previous task if it's running
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        self.recognitionRequest = nil
        self.recognitionTask = nil
        node?.removeTap(onBus: 0)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ResultViewController {
            
        }
     }
 
    
}
