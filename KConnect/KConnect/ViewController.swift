//
//  ViewController.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/24.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import JWTDecode


class ViewController: UIViewController {

    @IBOutlet weak var loginId: UITextField!
    @IBOutlet weak var loginPwd: UITextField!
    @IBOutlet weak var autoLoginCheck: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    var autoLoginFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginBtn.layer.cornerRadius = 10
        
    }

    @IBAction func loginBtnAction(_ sender: Any) {
        LoadingService.showLoading()
        login()
    }
    
    @IBAction func autoLoginBtnAction(_ sender: Any) {
        if autoLoginFlag { //체크 된상태
            autoLoginCheck.setImage(UIImage(systemName: "squareshape"), for: .normal)
            autoLoginFlag = false
        }else { //체크 풀린상태
            autoLoginCheck.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            autoLoginFlag = true
        }
        //autologinFlag userDefault에 저장.-> 그리고 앱 실행할때 오토로그인 여부 확인 후 로그인 진행.
    }
    
    
    func login() {
        if loginId.text == nil || loginPwd.text == nil {
           makeToast(message: "아이디와 비밀번호를 입력하세요.")
        } else {
            let userId = loginId.text!
            let userPwd = loginPwd.text!
            
            let url = "https://kconnect.ksmartech.com:8443/login"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10
            
            let params = ["email" : userId, "password" : userPwd] as Dictionary
            do{
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("(ViewController-64Line) Http Body Error")
            }
            
            AF.request(request).responseString{ (response) in
                switch response.result{
                case .success(let resData):
                    print("(ViewController-71Line) resData: \(resData)")
                    let decoder = JSONDecoder()
                    let data = resData.data(using: .utf8)
                    
                    if let data = data, let loginModel = try? decoder.decode(LoginModel.self, from:data){
                        
                        let loginToken = loginModel.data.token
                        let TOKEN = loginModel.data.token
                        let jwt = try? decode(jwt: TOKEN)
                        
                        let saveSuccessToken: Bool = KeychainWrapper.standard.set(loginToken, forKey:"token" )
                        if saveSuccessToken{
                            print("(Viewcontroller-85Line)토큰 저장 완료")
                        }else{
                            print("(Viewcontroller-85Line)토큰 저장 실패")
                        }
                        
                        if let TOKEN = jwt {
                            let INF = infotmation(nbf: TOKEN.body["nbf"] as! Int, REQUIRE_PASSWORD_CHANGE: TOKEN.body["REQUIRE_PASSWORD_CHANGE"] as! Bool, TEAM_POSITION: TOKEN.body["TEAM_POSITION"] as! String, iat: TOKEN.body["iat"] as! Int, USER_ID: TOKEN.body["USER_ID"] as! Int, EMAIL: TOKEN.body["EMAIL"] as! String, NAME: TOKEN.body["NAME"] as! String, exp: TOKEN.body["exp"] as! Int, ROLE: TOKEN.body["ROLE"] as! String)
                            
                            
                            UserDefaults.standard.set(INF.nbf, forKey: "nbf")
                            UserDefaults.standard.set(INF.REQUIRE_PASSWORD_CHANGE, forKey: "REQUIRE_PASSWORD_CHANGE")
                            UserDefaults.standard.set(INF.TEAM_POSITION, forKey: "TEAM_POSITION")
                            UserDefaults.standard.set(INF.iat, forKey: "iat")
                            UserDefaults.standard.set(INF.USER_ID, forKey: "USER_ID")
                            UserDefaults.standard.set(INF.EMAIL, forKey: "EMAIL")
                            UserDefaults.standard.set(INF.NAME, forKey: "NAME")
                            UserDefaults.standard.set(INF.exp, forKey: "exp")
                            UserDefaults.standard.set(INF.ROLE, forKey: "ROLE")
                            
                            
                            
                            if INF.REQUIRE_PASSWORD_CHANGE == false {
                                
                                let viewControllerName = self.storyboard?.instantiateViewController(withIdentifier: "PwdChangeController")
                                viewControllerName?.modalTransitionStyle = .flipHorizontal
                                if let view = viewControllerName {
                                    view.modalTransitionStyle = .coverVertical
                                    view.modalPresentationStyle = .fullScreen
                                    let transition = CATransition()
                                            transition.duration = 0.5
                                            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                            transition.type = CATransitionType.push
                                            transition.subtype = CATransitionSubtype.fromRight
                                            self.view.window!.layer.add(transition, forKey: nil)
                                    self.present(view, animated: false, completion: nil)
                                    }
                            }else {
                               
                                
                                let storyboard = UIStoryboard(name: "EmployeeStoryboard", bundle: nil)
                                
                                let settingBoard = storyboard.instantiateViewController(withIdentifier: "EmployeeMainPage")
                                settingBoard.modalPresentationStyle = .fullScreen
                                let transition = CATransition()
                                        transition.duration = 0.5
                                        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                        transition.type = CATransitionType.push
                                        transition.subtype = CATransitionSubtype.fromRight
                                        self.view.window!.layer.add(transition, forKey: nil)
                                self.navigationController?.pushViewController(settingBoard, animated: true)
                    
                            }
                        }
                        
                    } else {
                        print("(ViewController-139Line) decode error")
                        let alert = UIAlertController(title: "알림", message: "아이디와 비밀번호를 확인하십시오.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "확인", style: .default){ (ok) in
                           
                        }
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                case . failure(let error):
                    print(error)
                }
                
            }
            
        }
        LoadingService.hideLoading()
    }
    
    func makeToast(message : String) {
              let width:CGFloat = 20 // 가로 크기 지정
              let toastLabel = UILabel(frame: CGRect(x: width, y: self.view.frame.size.height-100, width: view.frame.size.width-2*width, height: 50)) // 세로 크기 및 동적 속성 지정
              
              // 뷰가 위치할 위치를 지정
              toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6) // 배경 색상
              toastLabel.textColor = UIColor.white // 텍스트 색상
              toastLabel.textAlignment = .center; // 텍스트 정렬
              toastLabel.text = message // 메시지
              toastLabel.alpha = 1.0 // 투명도
              toastLabel.layer.cornerRadius = 10 // 코너 둥글기
              toastLabel.clipsToBounds  =  true //코너 둥글기 활성화
              self.view.addSubview(toastLabel) // 뷰 컨트롤러에 추가
              
              // [애니메이션 동작 실시]
              UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                  toastLabel.alpha = 0.0
              }, completion: {(isCompleted) in
                  toastLabel.removeFromSuperview() // 뷰컨트롤러에서 제거
              })
          }
    
    
}

