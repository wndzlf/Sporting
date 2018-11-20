//import UIKit
//import Foundation
//
//class Room{
//    let teamName : String
//    let sports : String
//    let date : Date
//    let peopleTotal : Int
//    let peopleNeed : Int
//    let person : [Person]
//    let notice : String
//    let place : String
//    let roomCaptain : Person
//
//    init (teamName:String, sports:String, date:Date, peopleTotal : Int, peopleNeed : Int, person:[Person], notice:String, place:String,roomCaptain:Person){
//        self.teamName = teamName
//        self.sports = sports
//        self.date = date
//        self.peopleTotal = peopleTotal
//        self.peopleNeed = peopleNeed
//        self.person = person
//        self.notice = notice
//        self.place = place
//        self.roomCaptain = roomCaptain
//    }
//    
//}
//enum PersonType {
//    case captain
//    case member
//}
//
//class Person{
//    let name : String
//    let id : String
//    let friend : Int
//    let count : Int
//    let personType : PersonType
//    var favorite : [String]?
//
//    init(name:String, id:String, friend:Int, count:Int, personType:PersonType){
//        self.name = name
//        self.id = id
//        self.friend = friend
//        self.count = count
//        self.personType = personType
//    }
//}
//let person1 = Person(name: "Hanna", id: "gkssk925", friend: 2, count: 5, personType: .member)
//let person2 = Person(name: "Seungyeon", id: "yeon8033", friend: 1, count:3, personType: .member)
//let person3 = Person(name: "Joonghyun", id: "dkfjais", friend: 5, count: 0, personType: .captain)
