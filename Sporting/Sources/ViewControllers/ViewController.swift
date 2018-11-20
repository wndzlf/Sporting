import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            //효과 없음 false
            //self.moveToTabar(ani:false)
        }
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.emailField.text = "존재하는 email입니다"
                    return
                }
                guard let uid = user?.user.uid else {
                    return
                }
                print("성공!")
                //인증 성공
                let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
                let userReference = ref.child("users").child(uid)
                let values = ["email": email , "password": password]
                userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print(err)
                        return
                    }
                    print("Firebase에 유저정보를 저장했습니다.")
                })
            })
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
     if let email = emailField.text, let password = passwordField.text {
        Auth.auth().signIn(withEmail: email, password: password, completion: { user, error in
            if let firebaseError = error {
                print(firebaseError.localizedDescription)
                self.passwordField.text = ""
                return
            }
            //태이블 컨트롤러로 이동한다.
            self.moveToTabar(ani:true)
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
}
