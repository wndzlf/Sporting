import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

//UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate

class ChatLogController :  UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    var rooms:Rooms?{
        didSet{
            navigationItem.title = rooms?.roomTeamName
            observeMessages()
        }
    }
    var messages:[String] = []
    //해당방의 메시지를 모두 불러온다. 지금 현재 불러오는거 성공함
    func observeMessages(){
        //해당방의 UID에서 메시지들을 꺼내보자 snapshot.key가 메시지들의 고유한 값들
        let userMessagesRef = Database.database().reference().child("rooms").child((rooms?.roomUID!)!).child("messages")
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let messageRef = Database.database().reference().child("messages").child(snapshot.key)
            messageRef.observe(.value, with: { (snapshot2) in
                //print(snapshot2.value)
                if let dictionary = snapshot2.value as? [String:Any]{
                    if let text = dictionary["text"] as? String{
                        print(text)
                        self.messages.append(text)
                        self.collectionView?.reloadData()
                    }
                }
            })
        }
    }
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //채팅창의 화면
       
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.reloadData()
        collectionView?.alwaysBounceVertical = true
        
//        let cellWidth : CGFloat = collectionView!.frame.size.width / 4.0
//        let cellheight : CGFloat = collectionView!.frame.size.height - 2.0
        let cellSize = CGSize(width: 300 , height:500)
        
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        //layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        //layout.minimumLineSpacing = 1.0
        //layout.minimumInteritemSpacing = 1.0
        collectionView?.setCollectionViewLayout(layout, animated: true)
        
        setInputComponents()
    }
    
    let inputTextField:UITextField = {
        let TextField = UITextField()
        //TextField.placeholder = "Enter Message"
        TextField.translatesAutoresizingMaskIntoConstraints = false
        //TextField.delegate = self
        return TextField
    }()
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("good \(messages.count)")
        return messages.count
    }
    //이게 실행이안됨
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        print("this is indexPath")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        print("왜 실행이 안되냐고 ㅡㅡ")
        cell.textView.text = messages[indexPath.item]
        //print("이게 실행 안되 ㅜㅜ \(messages[indexPath.item])")
        
        //cell.backgroundColor = UIColor.red
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("실행 되는것인가 ...")
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func setInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        //view.addSubview(collectionView!)
//        //ios9 constraint anchors
//        //x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let sendButton = UIButton(type: .system)
        sendButton.setTitle("보내기", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: UIControlEvents.touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        //text
        containerView.addSubview(inputTextField)
//        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant:8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        //leftAnchor
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

        let separaterLineView = UIView()
        separaterLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separaterLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separaterLineView)

        separaterLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separaterLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separaterLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separaterLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func handleSend(){
        print("gogossing")
        let ref = Database.database().reference().child("rooms").child((rooms?.roomUID!)!).child("messages")
        let childRef = ref.childByAutoId()
        print("this is chidRef \(childRef)")
        print(childRef.key)
        
        let FromId = Auth.auth().currentUser!.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text":inputTextField.text! , "roomId":rooms?.roomUID! ,
                      "FromId":FromId, "timestamp":timestamp] as [String : Any]
        childRef.updateChildValues(values)
        
        let messageRef = Database.database().reference().child("messages").child(childRef.key!)
        messageRef.updateChildValues(values)
        
        //messages에 저장
        //rooms 의 messages의 배열에 메시지의 고유한 값을 저장.
        let userMessagRef = Database.database().reference().child("rooms").child((rooms?.roomUID!)!).child("messages")
        
        let messageId = childRef.key
        userMessagRef.updateChildValues([messageId:1])
    }
}

















