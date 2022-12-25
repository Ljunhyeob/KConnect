//
//  PwdChangeController.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/24.
//

import UIKit
import Alamofire


class PwdChangeController: UIViewController {
    
    @IBOutlet weak var nowPwd: UITextField!
    @IBOutlet weak var newPwd: UITextField!
    @IBOutlet weak var newPwdCheck: UITextField!
    @IBOutlet weak var changeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        changeBtn.layer.cornerRadius = 10
    }
    
    @IBAction func changeBtnAction(_ sender: Any) {
    }
    
    func change(){
        if nowPwd.text == nil {
            let alert = UIAlertController(title: "알림", message: "기존 비밀번호를 입력하세요.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default){ (ok) in
                return
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else if newPwd.text == nil {
            let alert = UIAlertController(title: "알림", message: "신규 비밀번호를 입력하세요.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default){ (ok) in
                return
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else if newPwd.text != newPwdCheck.text {
            let alert = UIAlertController(title: "알림", message: "신규 비밀번호가 다릅니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default){ (ok) in
                return
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: "알림", message: "비밀번호를 변경 하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default){ (ok) in
            
        }
        let cancel = UIAlertAction(title: "취소", style: .default){ (cancel) in
            return
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        let pwd = nowPwd.text!
        let newPwd = newPwd.text!
        
        let url = "https://kconnect.ksmartech.com:8443/init"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PUT"
        request.headers = APIManager.getAPIHeader()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
       
       
       let params = ["password" : "\(pwd)","newPassword" : "\(newPwd)"] as Dictionary
       do{
           try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
           
       }catch{
           print("(PwdChangeController - 79Line) http Body Error")
       }
        
        AF.request(request).responseString{ (response) in
            switch response.result{
            case .success(let resData):
                print("(PwdChangeController - 85Line) resData: ",resData)
            case .failure(let error):
                print("(PwdChangeController - 87Line) 에러에러에러",error)
            }
        }
        
        
    }
}
