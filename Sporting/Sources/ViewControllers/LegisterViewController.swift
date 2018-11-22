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
                    let alert = UIAlertController(title: "경고", message: "존재하는 이메일입니다.", preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:nil)
                    
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.passwordField1.text = ""
                    
                    print(firebaseError.localizedDescription)
                    return
                }
                //회원가입 성공
                guard let uid = user?.user.uid else {return}
                
                let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
                let userReference = ref.child("users").child(uid)
                let values = ["email": email , "password": password]
                
                userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        return
                    }
                    
                    let alert = UIAlertController(title: "성공", message: "회원가입이 완료되었습니다.", preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    print("유저 정보 저장 완료")
                })
            })
        }
    }
    
    func  moveToTabar(ani:Bool,iden:String) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInVC:UITabBarController = storyboard.instantiateViewController(withIdentifier: iden) as! UITabBarController
        self.present(loggedInVC, animated: ani, completion: nil)
    }
    
    func  moveToView(ani:Bool,iden:String) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: iden) 
        self.present(loggedInVC, animated: ani, completion: nil)
    }
}
