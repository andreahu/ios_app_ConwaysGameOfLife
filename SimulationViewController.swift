//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

let SResetNoticationName = Notification.Name(rawValue: "sResetUpdate")
let SaveNoticationName = Notification.Name(rawValue: "saved")

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func nameTextFieldDidEndOnExit(_ sender: UITextField) {
        print("keyboard disappear after done")
    }
    
    func engine(didUpdate: Engine) {//to conform EngineDelegate
        self.gridView.setNeedsDisplay()
    }
    
    subscript(pos: GridPosition) -> CellState {//to conform GridViewDataSource
        get { return Engine.sharedInstance.grid[pos.row, pos.col] }
        set { Engine.sharedInstance.grid[pos.row, pos.col] = newValue }
    }
    
    var size:Int {
        get { return Engine.sharedInstance.size }
        set { Engine.sharedInstance.size = newValue }
    }

    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.dataSource = self
        
        Engine.sharedInstance.delegate = self
        Engine.sharedInstance.updateClosure = { (engine:Engine) -> Void in
            self.gridView.setNeedsDisplay()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.gridView.setNeedsDisplay()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func step(_ sender: Any) {
        Engine.sharedInstance.grid = Engine.sharedInstance.grid.next()
        gridView.setNeedsDisplay()
    }
    
    
    
    @IBAction func resetGrid(_ sender: Any) {
        Engine.sharedInstance.size = Engine.sharedInstance.size
        gridView.setNeedsDisplay()
        
        //AH added notification
        let sResetNc = NotificationCenter.default
        let sResetinfo = ["sReset": self]
        sResetNc.post(name: SResetNoticationName, object: nil, userInfo:sResetinfo)
        
    }
    
    
    @IBAction func saveGrid(_ sender: Any) {
        var newC = [[Int]]()
        let allPositions = positionSequence (from: (0,0), to: (size-1,size-1))
        for position in allPositions{
            if self[position] == .alive {
                newC.append([position.row, position.col])
            }
        }
        Engine.sharedInstance.name = nameTextField.text!
        let newConf = Configuration(t: nameTextField.text!, c:newC)
        let recode = try! JSONEncoder().encode(newConf)
        let defaults = UserDefaults.standard
        defaults.set(recode, forKey: "simulationConfiguration")
        
        let saveNc = NotificationCenter.default
        let saveinfo = ["sReset": self]
        saveNc.post(name: SaveNoticationName, object: nil, userInfo:saveinfo)
        
        

    }
}

