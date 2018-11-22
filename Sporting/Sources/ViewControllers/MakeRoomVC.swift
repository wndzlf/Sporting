//
//  MakeRoomVC.swift
//  Sporting
//
//  Created by admin on 20/11/2018.
//  Copyright © 2018 multi. All rights reserved.
//

import UIKit
import Firebase

class MakeRoomVC: UIViewController {

    @IBOutlet var teamName: UITextField!
    @IBOutlet var location: UITextField!
    @IBOutlet var meetingTime: UITextField!
    @IBOutlet var notification: UITextField!
    var currentSportNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let sportsNum = currentSportNum else {return}
        
        if let titleString = Sports(rawValue: sportsNum)?.placeHolder {
            self.title = titleString + " 방생성"
        }
        let rightBarbuttonItem = UIBarButtonItem(title: "생성", style: .done, target: self, action: #selector(handleComplete))
        self.navigationItem.rightBarButtonItem = rightBarbuttonItem
    }
    
    //방 등록
    @objc func handleComplete() {
        let roomRef = Database.database().reference().child("rooms")
        let roomId = roomRef.childByAutoId()
        guard let roomSports = currentSportNum else {return}
        let roomSportsString = String(roomSports)
        
        let values = ["roomTeamName":teamName.text!, "roomSports":roomSportsString, "roomNotification":notification.text!,"roomPlace":location.text!, "roomMeetingTime":meetingTime.text!] as [String:Any]
        roomId.updateChildValues(values)
        
        guard let usrId = Auth.auth().currentUser?.uid else {return}
        let usrRef = Database.database().reference().child("users").child(usrId).child("groups")
    
        print("roomid")
        guard let roomUID = roomId.key else {return}
        print(roomUID)
        let values2 = [String(describing: roomUID):1]  as [String: Any]
        
        usrRef.updateChildValues(values2) { (err, ref) in
            if err != nil {
                return
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}
