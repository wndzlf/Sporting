import UIKit
import Firebase

class Message: NSObject {
    var FromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var toId: String?
    var videoUrl: String?
    var roomId: String?
    
    func chatPartnerId() -> String? {
        return FromId == Auth.auth().currentUser?.uid ? toId : FromId
    }
}
