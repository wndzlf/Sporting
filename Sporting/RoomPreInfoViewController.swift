//
//  RoomPreInfoViewController.swift
//  
//
//  Created by admin on 09/11/2018.
//

import UIKit
import Firebase

class RoomPreInfoViewController: UIViewController{

    var currentSportNum:Int?
    let cellId = "cellId"
    var reCount = 0
    var rooms = [Rooms]()
    let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        fetchRooms()
        
        view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.register(RoomCell.self, forCellReuseIdentifier: cellId)
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
    }
    
    func fetchRooms() {
        let userRef = Auth.auth()
        Database.database().reference().child("rooms").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let room = Rooms()
                room.roomUID = snapshot.key
                let roomCaptainUID = dictionary["roomCaptainUID"]
                let roomNotification = dictionary["roomNotification"]
                let roomPicture = dictionary["roomPicture"]
                let roomSports = dictionary["roomSports"]
                let roomTeamName = dictionary["roomTeamName"]
                //let roomPlace = dictionary["roomPlace"]
                //let roomDateTime = dictionary["roomDate-time"]
                
                room.roomCaptainUID = roomCaptainUID as! String
                room.roomNotification = roomNotification as! String
                room.roomPicture = roomPicture as! String
                room.roomTeamName = roomTeamName as! String
                room.roomSports = roomSports as! String
                // room.roomPlace = roomPlace as! String
                //room.roomDateTime = roomDateTime as! String

                guard let csn = self.currentSportNum else{
                    return
                }
                let roomSportsID = Int(room.roomSports!)
                if (roomSportsID == csn){
                    self.rooms.append(room)
                    self.tableView.reloadData()
                }
            }
        }
    }
}


extension RoomPreInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return rooms.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RoomCell
        let room = rooms[indexPath.row]
        
        //message노드안에 roomId 라는 key를 가진것을 저장 (i.e.g toid = asveqwetwetasdg)
        if let roomId = room.roomUID{
            //users영역에서 toid(asveqwetwetasdg) 에 해당하는 것을 찾아 그것의 레퍼런스를 ref에 저장.
            let ref = Database.database().reference().child("messages").child(roomId)
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]
                {
                    //cell.textLabel?.text = dictionary["roomTeamName"] as? String
                    //if let imageURL = dictionary["imageURL"] {
                    //cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: imageURL as! String)
                    //}
                }
                print(snapshot)
            }, withCancel: nil)
        }
        cell.textLabel?.text = room.roomTeamName
        cell.detailTextLabel?.text = room.roomNotification
        
        return cell
        
    }
}

extension RoomPreInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
