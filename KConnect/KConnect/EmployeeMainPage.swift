//
//  EmployeeMainPage.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/26.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import FSCalendar

class EmployeeMainPage: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
 
    
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var infoName: UILabel!
    @IBOutlet weak var infoTeamName: UILabel!
    @IBOutlet weak var infoPhoneNum: UILabel!
    @IBOutlet weak var infoUseDate: UILabel!
    @IBOutlet weak var infoTotalDate: UILabel!
    
    
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var vacationApplicationBtn: UIButton!
    @IBOutlet weak var vacationHistoryBtn: UIButton!
    @IBOutlet weak var vacationState: UILabel!
    
    @IBOutlet weak var vacationStartLabel: UILabel!
    @IBOutlet weak var vacationStateLabel: UILabel!
    
    @IBOutlet weak var myVacationHistoryTable: UITableView!
    
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    
    //연차 승인 현황 cell 배열
    var applicationDateCell: [String] = [] //신청날짜
    var applicationStateCell: [String] = [] //상태
    var applicationVacationTypeCell: [String] = [] //연차유형
    var applicationStartDateCell: [String] = [] //시작날짜
    var applicationEndDateCell: [String] = [] //종료날짜
    var applicationCommentCell: [String] = [] //사유
    var applicationIdCell: [String] = [] // 휴가 id
    
    var dateArray: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //--------UI관련 코드---------//
        self.navigationItem.hidesBackButton = true // 네비게이션바 백 버튼 숨김.
        calendarView.scrollEnabled = false
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.layer.borderWidth = 1
        infoView.layer.cornerRadius = 10
        
        vacationApplicationBtn.layer.borderColor = UIColor.black.cgColor
        vacationApplicationBtn.layer.borderWidth = 1
        vacationApplicationBtn.layer.cornerRadius = 10
        
        vacationHistoryBtn.layer.borderColor = UIColor.black.cgColor
        vacationHistoryBtn.layer.borderWidth = 1
        vacationHistoryBtn.layer.cornerRadius = 10
        
        vacationState.sizeToFit()
        vacationStartLabel.sizeToFit()
        vacationStateLabel.sizeToFit()
        
        
        //--------UI관련 코드---------//
        
        
        
        //--------초기 실행 코드--------//
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerTitleFont = UIFont(name: "NotoSansKR-Medium", size: 16)
        calendarView.appearance.weekdayFont = UIFont(name: "NotoSansKR-Regular", size: 14)
        calendarView.appearance.titleFont = UIFont(name: "NotoSansKR-Regular", size: 14)
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        calendarView.appearance.headerTitleColor = UIColor.link
        calendarView.appearance.headerTitleAlignment = .center
        calendarView.headerHeight = 45
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.appearance.borderRadius = 5
        calendarView.appearance.titleDefaultColor = .black  // 평일
        calendarView.appearance.titleWeekendColor = .red    // 주말
        calendarView.layer.cornerRadius = 10
        calendarView.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0.2)
        calendarView.placeholderType = .none
        calendarView.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        //calendarView.appearance.eventSelectionColor = UIColor.white
        //calendarView.appearance.eventSelectionColor = UIColor.lightGray
//        calendarView.calendarHeaderView.backgroundColor = UIColor.lightGray
//        calendarView.calendarWeekdayView.backgroundColor = UIColor.gray
        
        getProfile() //내 정보 가져오기
        getVacationHistory() //연차 승인 현황 가져오기
        
        let teamPosition = UserDefaults.standard.string(forKey: "TEAM_POSITION")!
        //--------초기 실행 코드--------//
       
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        let alert = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default){ (ok) in
            UserDefaults.standard.removeObject(forKey: "loginId")
            UserDefaults.standard.removeObject(forKey: "loginPwd")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let settingBoard = storyboard.instantiateViewController(withIdentifier: "ViewController")
            settingBoard.modalPresentationStyle = .fullScreen
            let transition = CATransition()
                    transition.duration = 0.5
                    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                    self.view.window!.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(settingBoard, animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (cancle) in

        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func retryBtnAction(_ sender: Any) {
        //연차 승인 현황 새로고침 버튼
        LoadingService.showLoading()
        applicationDateCell.removeAll()
        applicationStateCell.removeAll()
        applicationVacationTypeCell.removeAll()
        applicationStartDateCell.removeAll()
        applicationEndDateCell.removeAll()
        applicationCommentCell.removeAll()
        applicationIdCell.removeAll()
        
        
        getVacationHistory()
    }
    
    @IBAction func vacationApplicationBtnAction(_ sender: Any) {
        //휴가 신청 버튼
    }
    
    
    @IBAction func vacationHistoryBtnAction(_ sender: Any) {
        //휴가 내역 버튼
    }
    
    //날짜 선택했을때 할 일
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            
    }
    
    // 선택된 날짜의 채워진 색상 지정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.lightGray
    }
    
    
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.dateArray.contains(date){
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicationStartDateCell.count
//        if tableView == myVacationHistoryTable{
//            return applicationStartDateCell.count
//        }
//            //팀장 결재 리스트
//            //return approvalDateCell.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if tableView == myVacationHistoryTable, let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? vacationStateCell{

            var date = applicationStartDateCell[indexPath.row]
            print("LJH date: ", date)
            setEvent(var: date)
            
            date.insert("-", at: date.index(date.startIndex, offsetBy: 4))
            date.insert("-", at: date.index(date.startIndex, offsetBy: 7))
            
            
            cell.vacationStartDate.text = date
            
                   if applicationStateCell[indexPath.row] == "반려"{
                       cell.vacationState.text = applicationStateCell[indexPath.row]
                       cell.vacationState.textColor = .red
                   } else if applicationStateCell[indexPath.row] == "승인"{
                       cell.vacationState.text = applicationStateCell[indexPath.row]
                       cell.vacationState.textColor = .blue
                   }else{
                       cell.vacationState.text = applicationStateCell[indexPath.row]
                       cell.vacationState.textColor = .black
                   }
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    //-----------함수------------//
    
    //내 정보 조회
     func getProfile(){
         let userId = UserDefaults.standard.string(forKey: "USER_ID")!
         let year = getYear()
         let url = "https://kconnect.ksmartech.com:8443/profile/\(userId)/\(year)"
         var request = URLRequest(url: URL(string: url)!)
         request.httpMethod = "GET"
         request.headers = APIManager.getAPIHeader()
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         request.timeoutInterval = 10
        
         AF.request(request).responseString{ [self] (response) in
             switch response.result{
             case .success(let resData):
                 let decoder = JSONDecoder()
                 let data = resData.data(using: .utf8)
                 
                 if let data = data, let profileModel = try? decoder.decode(ProfileModel.self, from: data){
                     
                     infoName.text! = profileModel.data.userName
                     infoTeamName.text! = profileModel.data.group[0].groupName
                     infoPhoneNum.text! = profileModel.data.phoneNumber
                     infoUseDate.text! = String(profileModel.data.usedDays)
                     infoTotalDate.text! = String(profileModel.data.totalDays)
                     
                     
                     
                     UserDefaults.standard.set(infoTotalDate.text!, forKey: "totalVacation") //총 연차 저장
                     UserDefaults.standard.set(infoUseDate.text!, forKey: "usedVacation") //사용 연차 저장
                                            
                 }else{
                     print("decode error")
                 }
                 
             case .failure(let error):
                 print("에러에러에러",error)
             }
         }
     }
    
    //연차 승인 현황
    func getVacationHistory(){
        let year = getYear()
        let url = "https://kconnect.ksmartech.com:8443/vacation/\(year)?page=0&size=20"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.headers = APIManager.getAPIHeader()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
       
        AF.request(request).responseString{ [self] (response) in
            switch response.result{
            case .success(let resData):
                let decoder = JSONDecoder()
                let data = resData.data(using: .utf8)
                
                if let data = data, let vacationHistoryModel = try? decoder.decode(VacationHistoryListModel.self, from: data){
                    
                 let count = vacationHistoryModel.data.content.count
                    
                    for i in 0..<count{
                        applicationIdCell.append(String(vacationHistoryModel.data.content[i].vacationID))
                        print("vacationId: ", vacationHistoryModel.data.content[i].vacationID)
                        
                        applicationDateCell.append(vacationHistoryModel.data.content[i].createDt)
                        
                        applicationVacationTypeCell.append(vacationHistoryModel.data.content[i].vacationType)
                        applicationStartDateCell.append(vacationHistoryModel.data.content[i].startDate)
                        applicationEndDateCell.append(vacationHistoryModel.data.content[i].endDate)
                        applicationCommentCell.append(vacationHistoryModel.data.content[i].comment)
                        if vacationHistoryModel.data.content[i].statusType == "APPROVAL"{
                            applicationStateCell.append("승인")
                        }else if vacationHistoryModel.data.content[i].statusType == "DENY"{
                            applicationStateCell.append("반려")
                        }else if vacationHistoryModel.data.content[i].statusType == "CANCEL"{
                            applicationStateCell.append("취소")
                        }else{
                            applicationStateCell.append("대기")
                        }
                    }
                    myVacationHistoryTable.reloadData()
                }
            case .failure(let error):
                print("에러에러에러",error)
            }
            LoadingService.hideLoading()
        }
    }
    
    
    func getYear() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: Date())
        return year
    }
    
    func setEvent(var days : String){
        let dfMatter = DateFormatter()
        dfMatter.locale = Locale(identifier: "ko_KR")
        dfMatter.dateFormat = "yyyyMMdd"
        let startDate = dfMatter.date(from: days)
        dateArray.append(startDate!)
        calendarView.reloadData()
    }
    
    //-----------함수------------//
    
}



class vacationStateCell : UITableViewCell{
    
    @IBOutlet weak var vacationStartDate: UILabel!
    @IBOutlet weak var vacationState: UILabel!
}

