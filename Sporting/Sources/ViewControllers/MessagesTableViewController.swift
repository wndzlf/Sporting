import UIKit
import Firebase
//두번째 탭
class MessagesTableViewController: UITableViewController {
    
    let cellId = "cellId"
    //users 정보를 배열에 저장
    //var users = [Users]()
    var rooms = [Rooms]()
    //마지막 메시지를 저장한다.
    var messages = [Message]()
    //그룹화 하기 위해서 이렇게 저장.
    var messagesDictionary = [String:Message]()
    //return값의 count저장.
     var reCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        fetchRooms()
        tableView.register(RoomCell.self, forCellReuseIdentifier: cellId)
        //observeMessages()
    }
    
    //셀을 선택 -> 현재 유저 groupsUID 에 저장.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatLogController = ChatLogController(collectionViewLayout:UICollectionViewLayout())
        chatLogController.rooms = self.rooms[indexPath.row]
        navigationController?.pushViewController(chatLogController, animated: true)
        
        if  let currentUserUID = Auth.auth().currentUser?.uid{
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
                    return
                }
                    //print("유저 데이터는 채팅방의 UID를 가진다.(중복되지 않는다)")
                }
            )
        }
    }
   
    //유저가 속한 방의 개수를 count에 저장한후 return
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var count = 0
        
            if  let currentUserUID = Auth.auth().currentUser?.uid{

            let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
            let userReference = ref.child("users").child(currentUserUID)
            let usersRoomsCount = userReference.child("groups")
                usersRoomsCount.observe(.value, with: { (snapshot) in
                    let dictionary = snapshot
                    count = Int(dictionary.childrenCount)
                    self.reCount = count
                }
            )
        }
        return self.reCount
    }
    
    //User에게 chatcontroller를 보여준다??
    func showChatControllerForUser(rooms: Rooms) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.rooms = rooms
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    //셀의 높이를 80으로 고정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //메시지를 안보여줄것이니 필요 없음
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let message = Message()
                let fromid = dictionary["FromId"] as? String
                //이부분이 방의 UID이면 되겠지.
                let roomId = dictionary["roomId"] as? String
                let text = dictionary["text"] as? String
                let timeStamp = dictionary["timeStamp"] as? NSNumber
                
                message.FromId = fromid
                message.roomId = roomId
                message.text = text
                message.timeStamp = timeStamp
                
                //toid에 message를 누구에게 보내는지 들어있는 데이터 message.toId를 저장.
                //예를들어 abc에게 보낸다.
                if let roomId = message.roomId{
                    //messageDictionary에 key를 abc value는 message
                    self.messagesDictionary[roomId] = message
                    //messages의 배열에 messagesDictionary의 values만 넣는다.
                    self.messages = Array(self.messagesDictionary.values)
                }
                //self.messages.append(message)
                //print("aaaaaaaaaaaaaaaaaaaaaa")
                //print(message.text)
                //print(message.text)
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    //모든 방의 정보를 불러온다.
    func fetchRooms() {
        //현재 유저의 UID를 불러온후
        if  let currentUserUID = Auth.auth().currentUser?.uid{
        let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")//현재 로그인한 유저의 UID의 참조값을 저장
        var count = 0
        let userReference = ref.child("users").child(currentUserUID)//유저의 데이터에서 groups 밑에 rooms의 UID를 차곡차곡 저장

        let usersRoomsCount = userReference.child("groups").observe(.childAdded) { (snapshot1) in
                var room = Rooms()
                room.roomUID = snapshot1.key
                count = count + 1
                self.rooms.append(room)
        }
     Database.database().reference().child("groups").observe(.childAdded) { (snapshot) in
                for i in self.rooms{
                        //유저가 들어가있는 방과 firebase스냅샷에 있는 데이터를 비교
                            if snapshot.key == i.roomUID!{
                            if let dictionary = snapshot.value as? [String: Any] {
                                let roomCaptainUID = dictionary["roomCaptainUID"]
                                let roomDateTime = dictionary["roomDate-time"]
                                let roomNotification = dictionary["roomNotification"]
                                let roomPicture = dictionary["roomPicture"]
                                let roomPlace = dictionary["roomPlace"]
                                let roomSports = dictionary["roomSports"]
                                let roomTeamName = dictionary["roomTeamName"]

                                i.roomCaptainUID = roomCaptainUID as? String
                                i.roomDateTime = roomDateTime as? String
                                i.roomNotification = roomNotification as? String
                                i.roomPicture = roomPicture as? String
                                i.roomPlace = roomPlace as? String
                                i.roomSports = roomSports as? String
                                i.roomTeamName = roomTeamName as? String
                                //print(i)
                                //print(i.roomTeamName)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //유저가 들어간 rooms를 찾아준다.
    //            userReference.child("groups").observe(.childAdded) { (snapshot) in
    //                for i in self.rooms{
    //                    //유저가 들어가있는 방과 firebase스냅샷에 있는 데이터를 비교
    //                    if snapshot.key == i.roomUID!{
    //                        if let dictionary = snapshot.value as? [String: Any] {
    //                            let roomCaptainUID = dictionary["roomCaptainUID"]
    //                            let roomDateTime = dictionary["roomDate-time"]
    //                            let roomNotification = dictionary["roomNotification"]
    //                            let roomPicture = dictionary["roomPicture"]
    //                            let roomPlace = dictionary["roomPlace"]
    //                            let roomSports = dictionary["roomSports"]
    //                            let roomTeamName = dictionary["roomTeamName"]
    //
    //                            i.roomCaptainUID = roomCaptainUID as? String
    //                            i.roomDateTime = roomDateTime as? String
    //                            i.roomNotification = roomNotification as? String
    //                            i.roomPicture = roomPicture as? String
    //                            i.roomPlace = roomPlace as? String
    //                            i.roomSports = roomSports as? String
    //                            i.roomTeamName = roomTeamName as? String
    //
    //                            print("1231234123412341234")
    //                        }
    //                        self.tableView.reloadData()
    //                    }
    //                }
    //            }
    //}
    //각 table의 셀에
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RoomCell
        let room = rooms[indexPath.row]
        //message노드안에 roomId 라는 key를 가진것을 저장 (i.e.g toid = asveqwetwetasdg)
        if let roomId = room.roomUID{
            //users영역에서 toid(asveqwetwetasdg) 에 해당하는 것을 찾아 그것의 레퍼런스를 ref에 저장.
            let ref = Database.database().reference().child("messages").child(roomId)
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]
                {
                }
               // print(snapshot)
            }, withCancel: nil)
        }
        cell.textLabel?.text = room.roomTeamName
        //print(cell.textLabel?.text)
        cell.detailTextLabel?.text = room.roomNotification
        //print(cell.detailTextLabel?.text)
        return cell
    }
}

