//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by AH on 8/3/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

typealias GridEditorUpdateClosure = (Configuration) -> Void

class GridEditorViewController: UIViewController, GridViewDataSource{
    var configuration: Configuration!
    var updateClosure: GridEditorUpdateClosure?
    
    var engine: Engine = Engine(rows:100, cols: 100)// Instead of using the shareEengineInstance, we make our own copy of engine.

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gridView: GridView!
    
    subscript(pos: GridPosition) -> CellState {//to conform GridViewDataSource
        get { return engine.grid[pos.row, pos.col] }
        set { engine.grid[pos.row, pos.col] = newValue }
    }
    
    var size:Int {
        get { return engine.size }
        set { engine.size = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = configuration.title
        
        gridView.dataSource = self
        for record in configuration.contents! {
            gridView.dataSource![(record[0], record[1])] = .alive
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //let keyboard disappear after hitting return key on the keyboard
    @IBAction func nameTextFieldDidEndOnExit(_ sender: UITextField) {
    }
    
 
    @IBAction func publish(_ sender: Any) {
        var newC = [[Int]]()
        //in Grid file: public func positionSequence (from: GridPosition, to: GridPosition) -> GridPositionSequence
        let allPositions = positionSequence (from: (0,0), to: (99,99))
        for position in allPositions{
            if gridView.dataSource![position] == .alive {
                newC.append([position.row, position.col])
            }
        }
   
        let newConf = Configuration(t: nameTextField.text!, c:newC)
        
        updateClosure?(newConf)
        Engine.sharedInstance = engine
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    

}
