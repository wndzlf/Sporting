import UIKit
import Firebase

//지금 현재는 모든 방을 출력함, 해당 스포츠와 날짜로 필터링 하는 부분이 필요하다.
class FilteringUsingSportsDateTableViewController: UITableViewController {
    
    let cellId = "FilteringCellId"
    //users 정보를 배열에 저장
    //var users = [Users]()
    var rooms = [Rooms]()
    //마지막 메시지를 저장한다.
    var messages = [Message]()
    //그룹화 하기 위해서 이렇게 저장.
    var messagesDictionary = [String:Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRooms()
        tableView.register(RoomCell.self, forCellReuseIdentifier: cellId)
        //observeMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //chatLogController에 저장하고
        let chatLogController = ChatLogController(collectionViewLayout:UICollectionViewLayout())
        //현재의 navigationController에 push를 한다.
        chatLogController.rooms = self.rooms[indexPath.row]
        //print("this is chatlogcontroller.rooms \(chatLogController.rooms)")
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
                //print("유저 데이터는 채팅방의 UID를 가진다.(중복되지 않는다)")
            })}
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //유저가 속한 방만 데려온다.
    func fetchRooms() {
        let userUID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userUID!).child("groups").observe(.childAdded) { (snapshot) in
            let roomID = snapshot.key
        Database.database().reference().child("rooms").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let room = Rooms()
                if snapshot.key == roomID {
                    room.roomUID = snapshot.key
                    guard let roomCaptainUID = dictionary["roomCaptainUID"] as? String else {return}
                    //let roomDateTime = dictionary["roomDate-time"]
                    guard let roomNotification = dictionary["roomNotification"]  as? String else {return}
                    guard let roomPicture = dictionary["roomPicture"]  as? String else {return}
                    guard let roomPlace = dictionary["roomPlace"]  as? String else {return}
                    //let roomSports = dictionary["roomSports"]
                    guard let roomTeamName = dictionary["roomTeamName"]  as? String else {return}
                    
                    room.roomCaptainUID = roomCaptainUID
                    //room.roomDateTime = roomDateTime as! String
                    room.roomNotification = roomNotification
                    room.roomPicture = roomPicture
                    room.roomPlace = roomPlace
                    room.roomTeamName = roomTeamName
                    //room.roomSports = roomSports as! Sports
                    self.rooms.append(room)
                    self.tableView.reloadData()
                    }
                }
            }
        }
    }

    //각 table의 셀에
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RoomCell
        let room = rooms[indexPath.row]
        
        //message노드안에 roomId 라는 key를 가진것을 저장 (i.e.g toid = asveqwetwetasdg)
        if let roomId = room.roomUID{
            //users영역에서 toid(asveqwetwetasdg) 에 해당하는 것을 찾아 그것의 레퍼런스를 ref에 저장.
            let ref = Database.database().reference().child("messages").child(roomId)
            ref.observe(.value, with: { (snapshot) in
//                if let dictionary = snapshot.value as? [String:AnyObject]
//                {
//                    //cell.textLabel?.text = dictionary["roomTeamName"] as? String
//                    //if let imageURL = dictionary["imageURL"] {
//                    //cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: imageURL as! String)
//                    //}
//                }
                //print(snapshot)
            }, withCancel: nil)
        }
        cell.textLabel?.text = room.roomTeamName
        cell.detailTextLabel?.text = room.roomNotification
    
        return cell
    }
    
}
