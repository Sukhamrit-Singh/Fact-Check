//
//  HistoryViewController.swift
//  FactCheckingSystemApp
//
//  Created by Sukhamrit Singh on 8/4/21.
//

import UIKit


class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyTbl: UITableView!
    
    var factCheckHistory = [
        "Barack Obama is the 51st prime-minister of the United States.",
        "Neil Armstrong, an astronaut, was the first man on the moon.",
        "Albert Einstein was a German physicist, widely acknowledged to be one of the greatest physicists of all time. Einstein is known for developing the theory of relativity, but he also made important contributions to the development of the theory of quantum mechanics.",
        "albert einstein was a scientist."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        historyTbl.rowHeight = UITableView.automaticDimension
//        historyTbl.estimatedRowHeight = 200
        
        historyTbl.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
        historyTbl.delegate = self
        historyTbl.dataSource = self
        historyTbl.separatorStyle = .none
        historyTbl.backgroundColor = .clear
        
        historyTbl.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.factCheckHistory.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.historyTbl.dequeueReusableCell(withIdentifier: "historyCell") as UITableViewCell?)!
        
        cell.selectionStyle = .none
                
        let p: CGFloat = 10
        var x:CGFloat = p
        var y:CGFloat = p
        var w:CGFloat = self.view.frame.width - 2*x
        var h:CGFloat = 100 - y
        
        let view = UIView(frame: CGRect(x: x, y: y, width: w, height: h))
        cell.addSubview(view)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        if ( indexPath.row % 2 == 0 ) {
            view.backgroundColor = .systemGray5
        } else {
            view.backgroundColor = .systemGray6
        }
        
        x = x + 5
        y = 0
        w = view.frame.width - 2*x
        h = view.frame.height - 2*y
        
        let cellLbl = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
        view.addSubview(cellLbl)
        cellLbl.clipsToBounds = true
        
        
        cellLbl.numberOfLines = 0
        // set the text from the data model
        cellLbl.text = self.factCheckHistory[indexPath.row]
        cellLbl.textColor = .black
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        showFactCheckResults()
    }
    
    func showFactCheckResults() {
        performSegue(withIdentifier: "showResultSegue2", sender: nil)
    }
}

