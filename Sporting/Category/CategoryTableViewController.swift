//
//  CategoryTableViewController.swift
//  Sporting
//
//  Created by admin on 02/11/2018.
//  Copyright © 2018 multi. All rights reserved.
//

import UIKit


extension CategoryTableViewController {
    func setupData() {
        let sport1 = Sport(title: "축구" , Image: UIImage(named: "soccer.png")!)
        let sport2 = Sport(title: "배드민턴" , Image: UIImage(named: "ski.png")!)
        let sport3 = Sport(title: "야구" , Image: UIImage(named: "swimming.png")!)
        let sport4 = Sport(title: "런닝" , Image: UIImage(named: "tennis.png")!)
        let sport5 = Sport(title: "요가" , Image: UIImage(named: "running.png")!)
        let sport6 = Sport(title: "스키" , Image: UIImage(named: "yoga.png")!)
        let sport7 = Sport(title: "테니스" , Image: UIImage(named: "baseball.png")!)
        let sport8 = Sport(title: "수영" , Image: UIImage(named: "badminton.png")!)
        sports = [sport1, sport2, sport3, sport4, sport5, sport6, sport7, sport8]
    }
}

class CategoryTableViewController: UITableViewController {
    
    var sports:[Sport]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        setupData()
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "스포츠"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sports.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CategoryTableViewCell
        cell.cellImage.image = sports[indexPath.row].Image
        cell.cellImage.contentMode = .scaleAspectFit
        cell.cellTitle.text = sports[indexPath.row].title
        return cell
    }
    
}

