//
//  PwdChangeController.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/24.
//

import UIKit


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
}
