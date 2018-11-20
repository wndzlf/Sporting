import UIKit
import FirebaseAuth
import FirebaseDatabase

//로그인
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil{
//            //이미 들어 가있는 사람은 로그인 화면이 뜨지 않는다.
//           self.moveToTabar(ani:false)
//        }
    }
    @IBAction func loginOregister(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            moveToView(ani: false, iden: "login")
        case 1:
           moveToView(ani: false, iden: "register")
        default :
            break
        }
    }
    @IBAction func loginTapped_(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.passwordField.text = ""
                    return
                }
                //태이블 컨트롤러로 이동한다.
                self.moveToTabar(ani:true)
                curUsers.email = self.emailField.text
                curUsers.password = self.passwordField.text
                print("로그인 성공!")
            })
        }
    }
    
    //테이블 컨트롤러로 이동하기 위한 코드
    func  moveToTabar(ani:Bool) {
        //메인
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //탭바컨트롤러의 스토리보드 아이디 = LoggedInVC 이것을 이용해서 다음 화면으로 넘어간다.
        let loggedInVC:UITabBarController = storyboard.instantiateViewController(withIdentifier: "LoggedInVC") as! UITabBarController
        self.present(loggedInVC, animated: ani, completion: nil)
    }
    
    //다른 뷰로 넘어간다.
    func  moveToView(ani:Bool,iden:String) {
        //메인
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //탭바컨트롤러의 스토리보드 아이디 = LoggedInVC 이것을 이용해서 다음 화면으로 넘어간다.
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: iden) 
        self.present(loggedInVC, animated: ani, completion: nil)
    }
}
