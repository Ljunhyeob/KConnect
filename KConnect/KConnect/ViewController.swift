//
//  ViewController.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/24.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var loginId: UITextField!
    @IBOutlet weak var loginPwd: UITextField!
    @IBOutlet weak var autoLoginCheck: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    var autoLoginFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func autoLoginBtnAction(_ sender: Any) {
        
        if autoLoginFlag { //체크 된상태
            autoLoginCheck.setImage(UIImage(systemName: "squareshape"), for: .normal)
            autoLoginFlag = false
        }else { //체크 풀린상태
            autoLoginCheck.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            autoLoginFlag = true
        }
    }
    
    
    
    


}

