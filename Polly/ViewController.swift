//
//  ViewController.swift
//  Polly
//
//  Created by Carsten Witzke on 24/02/2017.
//  Copyright © 2017 Carsten Knoblich. All rights reserved.
//

import UIKit
import AVFoundation
import AWSPolly


class ViewController: UIViewController {
    
    @IBOutlet weak var greeterLabel: UILabel! {
        didSet {
            greeterLabel.text = NSLocalizedString("Your name please", comment: "")
        }
    }
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var restBtn: UIBarButtonItem!
    
    
    private lazy var audioPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameInput.delegate = self
        
        say(text: greeterLabel.text!)
    }
    
    @IBAction func onReset(_ sender: Any) {
        nameInput.text = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            if let text = self?.greeterLabel.text {
                self?.say(text: text)
            }
        }
    }
    
    
    fileprivate func say(text: String, voice: AWSPollyVoiceId = .joanna, completion: (() -> Void)? = nil) {
        let input = AWSPollySynthesizeSpeechURLBuilderRequest()
        input.text = text
        input.outputFormat = .mp3
        // US default
        input.voiceId = voice
        
        let builder = AWSPollySynthesizeSpeechURLBuilder.default().getPreSignedURL(input)
        builder.continueOnSuccessWith { [weak self] (awsTask) -> Any? in
            guard let url = awsTask.result as? URL else {
                return nil
            }
            
            self?.audioPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
            self?.audioPlayer.play()
            
            return nil
        }
    }
}

extension ViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let name = nameInput.text {
            let text = "Hello \(name)! How are you?"
            
            let alert = UIAlertController(title: NSLocalizedString("Welcome!", comment: ""), message: text, preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(ok)
            
            present(alert, animated: true, completion: {
                self.say(text: text)
            })
        }
        
        return true
    }
}
