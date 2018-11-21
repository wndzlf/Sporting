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
                    print(firebaseError.localizedDescription)
                    self.emailField.text = "존재하는 email입니다"
                    return
                }
                guard let uid = user?.user.uid else {
                    return
                }
                let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
                let userReference = ref.child("users").child(uid)
                let values = ["email": email , "password": password]
                
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
