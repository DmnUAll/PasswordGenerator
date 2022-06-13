//
//  ViewController.swift
//  PasswordGenerator
//
//  Created by Илья Валито on 19.09.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var passwordLengthLabel: UILabel!
    @IBOutlet weak var passwordLengthSlider: UISlider!
    @IBOutlet weak var upperCaseSwitch: UISwitch!
    @IBOutlet weak var lowerCaseSwitch: UISwitch!
    @IBOutlet weak var numbersSwitch: UISwitch!
    @IBOutlet weak var specialSwitch: UISwitch!
    @IBOutlet weak var securityLevelProgress: UIProgressView!
    @IBOutlet weak var generatedPasswordField: UITextField!
    
    func successfullCopyMessage(){
        // Create the allerd window.
        let alertController = UIAlertController(
            title: "Password Coppied",
            message: "The password was copied to the phone memory!",
            preferredStyle: .alert
        )
        // Create the "Ok" button.
        let actionOK = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        // Add buttons to the alert controller window.
        alertController.addAction(actionOK)
     
        // Show alert window.
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordLengthSlider.value = 8
        
        // Disable the user interaction with text field.
        generatedPasswordField.isUserInteractionEnabled = false
    }

    @IBAction func passwordLengthChanged(_ sender: UISlider) {
        
        passwordLengthLabel.text = String(Int(passwordLengthSlider.value))
    }
    
    @IBAction func groupActivated(_ sender: UISwitch) {
        if sender.isOn{
            securityLevelProgress.progress += 0.25
        } else {
            securityLevelProgress.progress -= 0.25
        }
        
        switch securityLevelProgress.progress {
        case 0: securityLevelProgress.progressTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case 0.25: securityLevelProgress.progressTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case 0.50: securityLevelProgress.progressTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        case 0.75: securityLevelProgress.progressTintColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        case 1.00: securityLevelProgress.progressTintColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
        default: securityLevelProgress.progressTintColor = #colorLiteral(red: 1, green: 0.9843137255, blue: 0, alpha: 1)
        }
    }
    
    @IBAction func generateButtonPressed(_ sender: UIButton) {
    
        var groupsSet: Set<Characters.RawValue> = []
        
        if lowerCaseSwitch.isOn {
            groupsSet.insert(Characters.lowerCase.rawValue)
        }
        if upperCaseSwitch.isOn {
            groupsSet.insert(Characters.upperCase.rawValue)
        }
        if numbersSwitch.isOn {
            groupsSet.insert(Characters.numbers.rawValue)
        }
        if specialSwitch.isOn {
            groupsSet.insert(Characters.special.rawValue)
        }
        
        if groupsSet.count == 0{
            generatedPasswordField.text = "No groups selected"
        } else {
            generatedPasswordField.text = Password().generate(groupsSet, Int(passwordLengthSlider.value))
            
            // Enable the user interaction with text field. So we can copy the text in it.
            generatedPasswordField.isUserInteractionEnabled = true
        }
    }
    @IBAction func copyText(_ sender: UITextField) {
        // Disable the user interaction with text field.
        generatedPasswordField.isUserInteractionEnabled = false
        
        // Copy the text field text to the RAM(UIPasteboard)
        UIPasteboard.general.string = generatedPasswordField.text
        
        successfullCopyMessage()
    }
}

