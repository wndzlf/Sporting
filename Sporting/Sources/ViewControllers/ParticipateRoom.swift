import UIKit
import Firebase

class ParticipateRoom: UITableViewController {
    let cellId = "FilteringCellId"
    var rooms = [Rooms]()
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRooms()
        tableView.register(RoomCell.self, forCellReuseIdentifier: cellId)
        //observeMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //fetchRooms()
        //tableView.register(RoomCell.self, forCellReuseIdentifier: cellId)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatLogController = ChatLogController(collectionViewLayout:UICollectionViewLayout())
        chatLogController.rooms = self.rooms[indexPath.row]
        navigationController?.pushViewController(chatLogController, animated: true)
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
        let usrRef = ref.child("users").child(currentUserUID)
        let roomUID = self.rooms[indexPath.row].roomUID
        let values = [String(describing: roomUID!):1] as [String : Any]
        
        usrRef.child("groups").updateChildValues(values) { (err, ref) in
            if err != nil {
                //print(err)
                return
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func fetchRooms() {
        let userUID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userUID!).child("groups").observe(.childAdded) { (snapshot) in
            let roomID = snapshot.key
        Database.database().reference().child("rooms").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let room = Rooms()
                if snapshot.key == roomID {
                    room.roomUID = snapshot.key
//                    guard let roomCaptainUID = dictionary["roomCaptainUID"] as? String else {return}
                    guard let roomNotification = dictionary["roomNotification"]  as? String else {return}
//                    guard let roomPicture = dictionary["roomPicture"]  as? String else {return}
                   // guard let roomPlace = dictionary["roomPlace"]  as? String else {return}
                    guard let roomTeamName = dictionary["roomTeamName"]  as? String else {return}
                    //let roomDateTime = dictionary["roomDate-time"]
                    //let roomSports = dictionary["roomSports"]
                    
                    //room.roomCaptainUID = roomCaptainUID
                    room.roomNotification = roomNotification
                    //room.roomPicture = roomPicture
                    //room.roomPlace = roomPlace
                    room.roomTeamName = roomTeamName
                    //room.roomDateTime = roomDateTime as! String
                    //room.roomSports = roomSports as! Sports
                    
                    self.rooms.append(room)
                    self.tableView.reloadData()
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RoomCell
        let room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.roomTeamName
        cell.detailTextLabel?.text = room.roomNotification
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
        }
    }
}
