//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var numLiving: UITextField!
    @IBOutlet weak var numBorn: UITextField!
    @IBOutlet weak var numEmpty: UITextField!
    @IBOutlet weak var numDead: UITextField!
    
    var living: Int = 0
    var born: Int = 0
    var empty: Int = 0
    var died: Int = 0
    
    @IBAction func numReset(_ sender: UIButton) {
        living = 0
        born = 0
        empty = 0
        died = 0
        
        numLiving.text = String(living)
        numBorn.text = String(born)
        numEmpty.text = String(empty)
        numDead.text = String(died)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the statistic view said "I want to be notified when the the engine updates. It will get all of the notifications
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(engine(notified:)), name: EngineNoticationName, object: nil)
        
        
        let sResetNc = NotificationCenter.default
        sResetNc.addObserver(self, selector: #selector(sReset(notified:)), name: SResetNoticationName, object: nil)
    }
    
    @objc func engine(notified: Notification) {
        living += Engine.sharedInstance.grid.alive.count
        born += Engine.sharedInstance.grid.born.count
        empty += Engine.sharedInstance.grid.empty.count
        died += Engine.sharedInstance.grid.died.count
        
        numLiving.text = String(living)
        numBorn.text = String(born)
        numEmpty.text = String(empty)
        numDead.text = String(died)
    }
    
    @objc func sReset(notified: Notification){
        living = 0
        born = 0
        empty = 0
        died = 0
        
        numLiving.text = String(living)
        numBorn.text = String(born)
        numEmpty.text = String(empty)
        numDead.text = String(died)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

