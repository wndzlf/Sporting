import UIKit
import Firebase
import GoogleMaps

//세번째 탭
class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
let imagePicker = UIImagePickerController()
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func registerPersonal(_ sender: Any) {
        uploadPicture()
    }
    func uploadPicture() {
        let storageRef = Storage.storage().reference().child("MyImage")
        let metaData = StorageMetadata()
        
        guard let uploadData = UIImagePNGRepresentation(self.imageView.image!) else {return}
        //guard let uploadData = UIImagePNGRepresentation(chosenImage) else {return}
        print("아자차카타파하")
        
        storageRef.putData(uploadData, metadata: metaData, completion: { (meta, error) in
            guard let meta = meta else {
                print(error)
                return
            }
            storageRef.downloadURL(completion: { (url, err) in
                print("Download error: \(err), url: \(url)")
                    guard let imageURL = url else {return}
                    curUsers.imageURL = imageURL.absoluteString
                    print("가나다라마바사")
                    print(imageURL.absoluteString)
            })
//            meta?.storageReference?.downloadURL(completion: { (url, error) in
//                print("url")
//                print(url?.absoluteString)
//                if let imageURL = url?.absoluteString {
//                    curUsers.imageURL = imageURL
//                    if  let currentUserUID = Auth.auth().currentUser?.uid{
//                        let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
//                        let userReference = ref.child("users").child(currentUserUID)
//                        let values = ["email":curUsers.email ,"password":curUsers.password ,"imageURL":imageURL] as [String : Any]
//                        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//                            if err != nil{
//                                return
//                            }
//                            print("Firebase에 유저정보를 저장했습니다.")
//                        })}
//                }
//            }
            }
        )
    }

    @IBAction func loadImageButton(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        imageView.image = chosenImage
        imageView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

