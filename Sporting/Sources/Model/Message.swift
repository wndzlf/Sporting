import UIKit
import Firebase

class Message: NSObject {
    var FromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var roomId: String?
    
    override init() {
        
    }
    
    init(FromId:String, text: String, timeStamp:NSNumber, roomId:String) {
        self.FromId = FromId
        self.text = text
        self.timeStamp = timeStamp
        self.roomId = roomId
        
    }
}
