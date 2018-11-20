import UIKit
import FirebaseAuth
import FirebaseDatabase

//회원가입
class LegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordField1: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            moveToView(ani: false, iden: "login")
        case 1:
           moveToView(ani: false, iden: "register")
        default:
            break
        }
    }

    @IBAction func createAccount(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                if let firebaseError = error {
                    //존재하는 Email이라면
                    print(firebaseError.localizedDescription)
                    self.emailField.text = "존재하는 email입니다"
                    return
                }
                //user의 uid를 저장해서.
                guard let uid = user?.user.uid else {
                    return
                }
                //guard let 빠져나왔으니 성공
                print("성공!")
                //인증 성공
                let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
                //userReference 에 users라는 노드 밑에 uid를 저장한다.
                let userReference = ref.child("users").child(uid)
                let values = ["email": email , "password": password]
                //userReference.updataChildValues를 하면 values를 저장 할 수 있다.
                userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        //print(err)
                        return
                    }
                    print("Firebase에 유저정보를 저장했습니다.")
                })
            })
        }
    }
    func  moveToTabar(ani:Bool,iden:String) {
        //메인
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //탭바컨트롤러의 스토리보드 아이디 = LoggedInVC 이것을 이용해서 다음 화면으로 넘어간다.
        let loggedInVC:UITabBarController = storyboard.instantiateViewController(withIdentifier: iden) as! UITabBarController
        self.present(loggedInVC, animated: ani, completion: nil)
    }
    func  moveToView(ani:Bool,iden:String) {
        //메인
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //탭바컨트롤러의 스토리보드 아이디 = LoggedInVC 이것을 이용해서 다음 화면으로 넘어간다.
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: iden) 
        self.present(loggedInVC, animated: ani, completion: nil)
    }
}
