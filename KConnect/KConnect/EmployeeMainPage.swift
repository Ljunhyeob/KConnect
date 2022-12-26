//
//  EmployeeMainPage.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/26.
//

import UIKit

class EmployeeMainPage: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.hidesBackButton = true // 네비게이션바 백 버튼 숨김.
        
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
}
