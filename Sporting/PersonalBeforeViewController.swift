import UIKit
import Firebase
import GoogleMaps

//세번째 탭
class PersonalBeforeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   

    @IBOutlet weak var mapView: GMSMapView!
    
    let imagePicker = UIImagePickerController()
    
    //imageView.image에 사진이 저장되어있다.
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func registerPersonal(_ sender: Any) {
        uploadPicture()
    }
    func uploadPicture() {
        
        let storageRef = Storage.storage().reference().child("MyImage2.png")
        
        if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
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
                        curUsers.imageURL = imageURL
                        //이미 들어 가있는 사람은 로그인 화면이 뜨지 않는다.
                        //print(imageURL)
                        //현재 로그인 한사람의 UID에서
                        if  let currentUserUID = Auth.auth().currentUser?.uid{
                            //데이터베이스를 불러온후
                            let ref = Database.database().reference(fromURL: "https://realsporting-d74ae.firebaseio.com/")
                            //현재 로그인한 유저의 UID의 참조값을 저장
                            let userReference = ref.child("users").child(currentUserUID)
                            //현재 유저의 email, password, imageURL을 values값에 저장
                            let values = ["email":curUsers.email ,"password":curUsers.password ,"imageURL":imageURL] as [String : Any]
                            //현재 유저의 UID의 참조값에 child에 저장한다.
                            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                if err != nil{
                                    print(err)
                                    return
                                }
                                print("Firebase에 유저정보를 저장했습니다.")
                            })}
                    }
                }
                //print(metadata)
                //이미지 url을 유저의 정보에 저장한다. (사진은 storage 에 저장)
//                if Auth.auth().currentUser != nil{
//                    //imageURL에 사진이 저장되는 URL을 저장
//                }
                )}
        )}
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
    
//    왜안되는 코드인지 모르겠음
//    @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        print("111111")
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            print("2222222")
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = pickedImage
//            dismiss(animated: true, completion: nil)
//        }
//    }
    
//선택된 이미지를 chosenImage에 저장하고 imgeView.image 에 저장한다.
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = chosenImage
        imageView.contentMode = .scaleAspectFit
        //self.performSegue(withIdentifier: "ShowEditView", sender: self)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

