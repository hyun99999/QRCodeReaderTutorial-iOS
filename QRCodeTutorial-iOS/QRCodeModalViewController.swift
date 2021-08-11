//
//  QRCodeModalViewController.swift
//  QRCodeTutorial-iOS
//
//  Created by kimhyungyu on 2021/08/09.
//

import UIKit

class QRCodeModalViewController: UIViewController {

    @IBOutlet weak var qrcodeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(origin: .zero, size: qrcodeView.frame.size)
        let qrcode = QRCodeView(frame: frame)
        qrcode.generateCode("https://github.com/hyun99999", foregroundColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), backgroundColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        self.qrcodeView.addSubview(qrcode)
    }
}
