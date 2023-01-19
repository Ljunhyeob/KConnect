//
//  EmployeeVacationApplication.swift
//  KConnect
//
//  Created by 이준협 on 2023/01/19.
//

import Foundation
import UIKit

class EmployeeVacationApplication : UIViewController {

    @IBOutlet weak var infoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.layer.borderWidth = 1
        infoView.layer.cornerRadius = 10
        
        
    }
    
}
