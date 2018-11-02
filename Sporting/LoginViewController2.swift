import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            //효과 없음 false
            //self.moveToTabar(ani:false)
        }
    }
    
    
    @IBAction func LoginOrRegister(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            moveToTabar(ani: false, iden: "Login")
        case 1:
            moveToTabar(ani: false, iden: "Register")
        default:
            break
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.passwordField.text = ""
                    return
                }
                //태이블 컨트롤러로 이동한다.
                self.moveToTabar(ani:true,iden:"LoggedInVC")
                print("로그인 성공!")
            })
        }
    }
    //테이블 컨트롤러로 이동하기 위한 코드
    func  moveToTabar(ani:Bool,iden:String) {
        //메인
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //탭바컨트롤러의 스토리보드 아이디 = LoggedInVC 이것을 이용해서 다음 화면으로 넘어간다.
        let loggedInVC:UITabBarController = storyboard.instantiateViewController(withIdentifier: iden) as! UITabBarController
        self.present(loggedInVC, animated: ani, completion: nil)
    }
}

