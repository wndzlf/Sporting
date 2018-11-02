import UIKit
import FSCalendar

class CalendarViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    @IBOutlet weak var fsCalendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fsCalendar.allowsMultipleSelection = true //여러날짜를 동시에 선택할 수 있도록
        fsCalendar.clipsToBounds = true //달력 구분 선 제거
        fsCalendar.firstWeekday = 2
        
        self.tabBarController?.tabBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    //delegate함수 이함수를 실행해서 선택된 날짜를 print할 수 있다.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //print(self.formatter.string(from: date))
        //print(fsCalendar.selectedDate?.description)
        
        curUsers.date = date
        //유저데이터에 -1 되어서 들어간다. 이거는 라이브러리의 버그인거같음
        print("유저데이터에 들어간 날짜\(date)")
    }
    
    @IBAction func MakeRoom(_ sender: Any) {
        
    }
    

}

