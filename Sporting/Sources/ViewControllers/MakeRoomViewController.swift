import UIKit
import GoogleMaps
import Firebase

//방을 생성해야 방을 출력해 줄 수 있어서 조금 만저 볼게요
class MakeRoomViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var teamName: UITextField!
    
    let imagePicker = UIImagePickerController()
    //카메라 버튼 클릭
    @IBAction func LoadImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    //버튼을 누르면 원하는 데이터를 Room의 고유한 UID를 생성(childbyAutoId를 이용)
    @IBAction func MakeRoomButton(_ sender: Any) {
        let storageRef = Storage.storage().reference().child("Rooms.png")
        if let uploadData = UIImagePNGRepresentation(self.profileImage.image!){
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error)
                    print("에러났다에러났어")
                    return
                    }
                
                    metadata?.storageReference?.downloadURL(completion: { (url, error) in
                    if let error = error  {
                        return
                    }
                    
                   if let imageURL = url?.absoluteString {
                    //imageURL을 출력해보자
                    print("이미지 URL을 print해보자 \(imageURL)")
                    //현재 방의 UID에서 사용하자. database에서 rooms에 해당하는 레퍼런스를 ref에 저장.
                    let roomRef = Database.database().reference().child("rooms")
                    //방의 UID를 childRef가 가지고 있다.
                    let childRef = roomRef.childByAutoId()
                    //사진, 장소 , 날짜-시간, 공지사항 ,스포츠 ,방장
                    //방장의 uid를 roomCaptainUID에저장
                    let roomCaptainUID = Auth.auth().currentUser!.uid
                    //방생성히 해당 스포츠
                    let roomSports = String(describing: curUsers.sports!)
                    //방생성시 날짜
                    let timeStamp = Int(Date().timeIntervalSince1970)
                    //데이터베이스를 불러온후
                    let refDB = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
                    //let rooomReference = refDB
                    let values = ["roomPicture":imageURL,"roomPlace":"서울시 중랑구 신내동(google Apl 사용 요망)","roomDate-time":timeStamp,"roomNotification":"초보자들 안받아요 못하면 직접 뛰든가", "roomSports":roomSports, "roomCaptainUID":roomCaptainUID ,"roomTeamName":self.teamName.text] as [String : Any]                            //현재 유저의 UID의 참조값에 child에 저장한다.
                        childRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil{
                            print(err)
                            return
                        }
                        print("Firebase에 room의 정보를 저장했습니다.")
                        }
                    )
                    let values2 = ["messages":"방 을 처음 만들었습니다."] as [String:Any]
                    childRef.child("messages").updateChildValues(values2)

                    }


                   // if let imageURL = metadata?.downloadURL()?.absoluteString{
                })
             }
         )
        }
    }
    
    //날짜의 포맷
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월dd일"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        //datePicker의 설정을 시간으로하고 20분 단위로 설정한다.
        self.datePicker.datePickerMode = .time
        self.datePicker.minuteInterval = 10
        //tmpDate에 formatting한 날짜 데이터를 저장
        let tmpDate = self.formatter.string(from: curUsers.date!)
        //네비게이션 타이틀
        navigationItem.title = tmpDate + " 방생성"
        //텝바 숨키기
        self.tabBarController?.tabBar.isHidden = false
        //연 월 일 만 출력해보자
        print(self.formatter.string(from: curUsers.date!))
        let sports = curUsers.sports
        //선택한 스포츠 출력해보기
        print(sports)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //사진올리는 imagePickerController에 해당하는부분
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImage.image = chosenImage
        profileImage.contentMode = .scaleAspectFit
        //self.performSegue(withIdentifier: "ShowEditView", sender: self)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



