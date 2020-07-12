//
//  ConfigurationTableViewController.swift
//  FinalProject
//
//  Created by AH on 8/3/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

class ConfigurationTableViewController: UITableViewController {
    
    var fetcher = Fetcher()
    var configurations: [Configuration]!//a type of array of confirguration, unwrapped optional

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()//AH
        
        let saveNc = NotificationCenter.default
        saveNc.addObserver(self, selector: #selector(simulationSaved(notified:)), name: SaveNoticationName, object: nil)
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func simulationSaved(notified: Notification) {
        
        
        
        var newC = [[Int]]()
        let allPositions = positionSequence (from: (0,0), to: (Engine.sharedInstance.size-1,Engine.sharedInstance.size-1))
        for position in allPositions{
            if Engine.sharedInstance.grid[position.row,position.col] == .alive {
                newC.append([position.row, position.col])
            }
        }
        
        
        let newConf = Configuration(t: Engine.sharedInstance.name, c:newC)
        
            configurations.append(newConf)
            tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of sections
        //return configurations[section].count//AH codes
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return (configurations ?? []).count//P:if configuration is nill, that will return an empty array, otherwise it will return configurations. So it will either be 0 or the number of rows in configurations
    }

    
    //Fetch data from the Configuration URL(declared in Fetcher.swift) and parse into Configuration object
    func fetch() {//AH
        //if connect to a Button on storyboard: @IBAction func fetch(_ sender: UIButton) {
        guard let url = URL(string: ConfigurationURL) else { return }
        fetcher.fetch(url: url) { (response) in
            let op = BlockOperation {
                switch response {
                case .success(let data):
                    do {
                        self.configurations = try JSONDecoder().decode([Configuration].self, from: data)//decode data from the online JSon file (ConfigurationURL declared in Fetcher.swift)
                        self.tableView.reloadData()
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let msg):
                    print("\(msg)")
                }
            }
            OperationQueue.main.addOperation(op)
        }
    }
    
    //AH: Let the the sections from URL show up as cells in the Tableview (Blinker, Pentadecthlon, Glider Gun, Tumbler)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Configuration", for: indexPath)
        cell.textLabel?.text = configurations[indexPath.row].title ?? "No title"//set the title here. If the configuration doesn't have title, show "No title"
        return cell
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? GridEditorViewController else { return }//transition from one view controller to another view controller
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        destination.configuration = configurations[indexPath.row]
        
        destination.updateClosure = { (configuration) in //when I hit the save button on my GridEditor,it communicate back the changes that I've made to me
            
            self.configurations[indexPath.row] = configuration //AH codes. Used Lecture 8 logic
            
            self.tableView.reloadData()
        }
        
        
    }

}
