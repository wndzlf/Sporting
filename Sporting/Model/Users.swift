import UIKit

//유저의 정보, 이외에 imageURL ,자기소개, 검색장소를 저장 할 수 있도록 해야한다.
class Users: NSObject {
    var id:String?
    var password: String?
    var email: String?
    var sports: Sports?
    var date: Date?
    var imageURL: String?
    
}

var curUsers = Users()
