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
        
        let storageRef = Storage.storage().reference().child("MyImage")
        
        guard let uploadData = UIImagePNGRepresentation(self.imageView.image!) else {return}
        
        storageRef.putData(uploadData, metadata: nil, completion: { (meta, error) in
            //에러가 있으면
            if error != nil {
                    return
            }
            
            print(meta)
            
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

