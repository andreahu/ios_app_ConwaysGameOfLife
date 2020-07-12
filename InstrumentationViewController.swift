//
//  InstrumentationViewController.swift
//  FinalProject
//
//  Created by AH on 8/3/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var SizeTextField: UITextField!
    
    @IBAction func sizeStepper(_ sender: UIStepper) {
        SizeTextField.text = String(sender.value)
    }
    
    @IBOutlet weak var slider: UISlider!//slider object when my storyboard loads
    
    private var tableViewController: ConfigurationTableViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConfigurationTableViewController,
            segue.identifier == "EmbedSegue" {
            self.tableViewController = vc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func changeInterval(_ sender: UISlider) {
        let interval = Double(Int(sender.value))
        if Engine.sharedInstance.interval != interval {
            Engine.sharedInstance.interval = interval
        }
    }
    
    
    @IBAction func setOnOff(_ sender: UISwitch) {//switch button
        Engine.sharedInstance.interval = sender.isOn ? 0.5 : 0.0//if I throw the switch on, it's going to tell the engine.sharedInstance to set the timer going off every 0.5 second. Then in Grid.swift, it will fire the updateClosure ( the code in last line in  var interval:......self.updateClosure(self) )
    }
    
    
    @IBAction func add(_ sender: UIBarButtonItem) {//"+" button on the uppper right corner on the tab bar
        let newConf = Configuration(t: "new config", c:[[Int]]())
        tableViewController.configurations.append(newConf)
        tableViewController.tableView.reloadData()
    }
    
    
    
    // Size TextField funcs 
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("hey we are editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("hey we ended")
    }
    
    @IBAction func SizeTextFieldDidEndOnExit(_ textField: UITextField) {
        //below are the codes used for setting timer(for grid auto step). Need to revise to set grid Size
        //        guard let text = textField.text else { slider.value = 0.0; return }
        //        guard let interval = Double(text) else { slider.value = 0.0; return }
        //        guard interval >= Double(slider.minimumValue)
        //            && interval <= Double(slider.maximumValue) else { slider.value = 0.0; return }
        //        slider.value = Float(interval)
        //        if Engine.sharedInstance.interval != interval {
        //            Engine.sharedInstance.interval = interval
        //        }
        //        textField.resignFirstResponder()
        guard let text = SizeTextField.text else {return}
        guard let s = Int(text) else {return}
        Engine.sharedInstance.size = s
        SizeTextField.resignFirstResponder()
    }
    
    
    
 

}
