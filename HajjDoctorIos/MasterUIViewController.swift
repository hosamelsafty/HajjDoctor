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


class MasterUIViewController: UIViewController,SFSpeechRecognizerDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var logo: UIImageView!{
        didSet{
            logo.image = UIImage(named: "AppIcon")
        }
    }

    @IBOutlet weak var logoTitle: UILabel!
    
    @IBOutlet weak var recordView: UIView!
    var recordButton : RecordButton!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer : SFSpeechRecognizer? =  SFSpeechRecognizer(locale: Locale.init(identifier: "en"))
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var node : AVAudioInputNode?
    
    @IBOutlet weak var input: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeSpeech()
        
        // set up recorder button
        recordButton = RecordButton(frame: CGRect(x: 0,y: 0,width: 70,height: 70))
        //        recordButton.progressColor = .red
        recordButton.closeWhenFinished = false
        recordButton.addTarget(self, action: #selector(MasterUIViewController.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(MasterUIViewController.stop), for: UIControlEvents.touchUpInside)
        recordView.addSubview(recordButton)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func record() {
        //        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(MasterViewController.updateProgress), userInfo: nil, repeats: true)
        recordAndRecognizeSpeech()
    }
    
    @objc func stop() {
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
                print(result.bestTranscription.formattedString)
                self.input.text = result.bestTranscription.formattedString
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if let destination = segue.destination as? ResultViewController {
//
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    var possibleDisease = [String]()
    @IBAction func diagnose(_ sender: UIButton) {
        possibleDisease = ["hypertensive disease"]
        let alert = UIAlertController(title: "Possible Disease", message: possibleDisease.joined(separator: ","), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("get Medicine", comment: "help action"), style: .default, handler: {_ in
            if let medicineTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MedicineTableViewController") as? MedicineTableViewController {
                medicineTable.medicines = self.getMedicines(for : self.possibleDisease)
                self.navigationController?.pushViewController(medicineTable, animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getMedicines(for diseases: [String])->[Medicine]{
        return [Medicine(name:"water pills", decribe:"help lower blood pressure", selected:true), Medicine(name:"nitrates", decribe:"treat chest pain", selected:true)]
    }
}
