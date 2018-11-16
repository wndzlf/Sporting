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
                if let dictionary = snapshot2.value as? [String:Any]{
//                    guard let text = dictionary["text"] as? String
//
//                    guard let text = dictionary["text"] as? String
//                    guard let text = dictionary["text"] as? String
//                    let roomMessage: Message!
//                    roomMessage.roomId
//                    roomMessage.FromId
//                    roomMessage.text
//                    roomMessage.timeStamp
                    
                    if let text = dictionary["text"] as? String{
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
        
        let rightbutton = UIBarButtonItem(image: UIImage(named: "person"), style: .plain, target: self, action: #selector(notificationInfo))
        navigationController?.navigationItem.rightBarButtonItem = rightbutton
        
        //top padding , bottom padding messga
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        //채팅창의 화면
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.reloadData()
        collectionView?.alwaysBounceVertical = true
    
        let cellSize = CGSize(width: 300 , height:500)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        collectionView?.setCollectionViewLayout(layout, animated: true)
        
        setInputComponents()
    }
    @objc func notificationInfo() {
        
    }
    
    let inputTextField:UITextField = {
        let TextField = UITextField()
        TextField.translatesAutoresizingMaskIntoConstraints = false
        return TextField
    }()
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        
        cell.textView.text = messages[indexPath.item]
        cell.bubbleviewWidthAnchor?.constant = estimateFrameForText(text: messages[indexPath.item]).width + 32
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        //get estimated height
        let text = messages[indexPath.row]
        height = estimateFrameForText(text: text).height
        return CGSize(width: view.frame.width, height: height+30)
    }
    
    private func estimateFrameForText(text:String) -> CGRect {
        //text의 사이즈
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        //텍스트의 시스템 폰트 크기
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
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
        
        //룸의 메세지 참조
        let messageRefOfRoom = Database.database().reference().child("rooms").child((rooms?.roomUID!)!).child("messages")
        let messageID = messageRefOfRoom.childByAutoId()
        
        let FromId = Auth.auth().currentUser!.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text":inputTextField.text! , "roomId":rooms?.roomUID! ,
                      "FromId":FromId, "timestamp":timestamp] as [String : Any]
        
        
        messageID.updateChildValues(values)
    
        //메세지 자체의 참조
        let messageRef = Database.database().reference().child("messages").child(messageID.key!)
        messageRef.updateChildValues(values)
    }
}

















