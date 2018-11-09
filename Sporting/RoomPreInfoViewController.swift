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
        
        if let roomId = room.roomUID{
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let chatLogController = ChatLogController(collectionViewLayout:UICollectionViewLayout())
        chatLogController.rooms = self.rooms[indexPath.row]
        navigationController?.pushViewController(chatLogController, animated: true)
        //now
        
        //현재 유저의 UID를 불러오고실행, 이제는 선택된 그룹의 UID를 불러오자
        if  let currentUserUID = Auth.auth().currentUser?.uid{
            //                 //데이터베이스를 불러온후
            let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
            //현재 로그인한 유저의 UID의 참조값을 저장
            let userReference = ref.child("users").child(currentUserUID)
            //현재 유저의 email, password, imageURL을 values값에 저장
            let roomUID = self.rooms[indexPath.row].roomUID
            
            let values = ["email":curUsers.email ,"password":curUsers.password ,"imageURL":curUsers.imageURL] as [String : Any]
            
            let values2 = [String(describing: roomUID!):1] as [String : Any]
            
            //users->groups->groupUID가 들어간다. 채팅방에 들어가면 유저는 채팅방의 groupUID를 가지게 된다.
            userReference.child("groups").updateChildValues(values2, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err)
                    return
                }
                print("유저 데이터는 채팅방의 UID를 가진다.(중복되지 않는다)")
            })}
    }
}

extension RoomPreInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
