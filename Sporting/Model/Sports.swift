import UIKit

//스포츠를 enum으로 나눔
enum Sports: Int {
    case soccer = 0
    case badminton = 1
    case baseball = 2
    case running = 3
    case yoga = 4
    case ski = 5
    case tennis = 6
    case swimming = 7
    
    var placeHolder: String {
        switch self {
        case .soccer:
            return "축구"
        case .badminton:
            return "배드민턴"
        case .baseball:
            return "야구"
        case .running:
            return "런닝"
        case .yoga:
            return "요가"
        case .ski:
            return "스키"
        case .tennis:
            return "테니스"
        case .swimming:
            return "수영"
        default:
            break
        }
    }
}

