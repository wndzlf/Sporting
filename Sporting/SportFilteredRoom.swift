//
//  RoomPreInfoViewController.swift
//  
//
//  Created by admin on 09/11/2018.
//

import UIKit
import Firebase

class SportFilteredRoom: UIViewController{

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
        
        if let titleString = Sports(rawValue: currentSportNum!)?.placeHolder {
                self.title = titleString
        }

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
        //let userRef = Auth.auth()
        Database.database().reference().child("rooms").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let room = Rooms()
                room.roomUID = snapshot.key
                guard let roomCaptainUID = dictionary["roomCaptainUID"] as? String else {return}
                guard let roomNotification = dictionary["roomNotification"] as? String else {return}
                guard let roomPicture = dictionary["roomPicture"] as? String else {return}
                guard let roomSports = dictionary["roomSports"] as? String else {return}
                guard let roomTeamName = dictionary["roomTeamName"] as? String else {return}
                //let roomPlace = dictionary["roomPlace"]
                //let roomDateTime = dictionary["roomDate-time"]
                
                room.roomCaptainUID = roomCaptainUID
                room.roomNotification = roomNotification
                room.roomPicture = roomPicture
                room.roomTeamName = roomTeamName
                room.roomSports = roomSports
                // room.roomPlace = roomPlace as! String
                //room.roomDateTime = roomDateTime as! String

                guard let csn = self.currentSportNum else{ return }
                
                //스포츠 필터
                let roomSportsID = Int(room.roomSports!)
                if (roomSportsID == csn){
                    self.rooms.append(room)
                    self.tableView.reloadData()
                }
            }
        }
    }
}


extension SportFilteredRoom: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return rooms.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RoomCell
        let room = rooms[indexPath.row]
        
//        if let roomId = room.roomUID{
//            let ref = Database.database().reference().child("messages").child(roomId)
//            ref.observe(.value, with: { (snapshot) in
//                if let dictionary = snapshot.value as? [String:AnyObject]
//                {
//                    //cell.textLabel?.text = dictionary["roomTeamName"] as? String
//                    //if let imageURL = dictionary["imageURL"] {
//                    //cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: imageURL as! String)
//                    //}
//                }
//                print(snapshot)
//            }, withCancel: nil)
//        }
        
        cell.textLabel?.text = room.roomTeamName
        cell.detailTextLabel?.text = room.roomNotification
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let chatLogController = ChatLogController(collectionViewLayout:UICollectionViewLayout())
        chatLogController.rooms = self.rooms[indexPath.row]
        navigationController?.pushViewController(chatLogController, animated: true)

        guard let currentUserUID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
        let usrRef = ref.child("users").child(currentUserUID)
        let roomUID = self.rooms[indexPath.row].roomUID
        let values = [String(describing: roomUID!):1] as [String : Any]
        //let values = ["email":curUsers.email ,"password":curUsers.password ,"imageURL":curUsers.imageURL] as [String : Any]
        
        usrRef.child("groups").updateChildValues(values) { (err, ref) in
            print("123454213")
            print(values)
            if err != nil {
                //print(err)
                return
            }
            
        }
    }
}
extension SportFilteredRoom: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
