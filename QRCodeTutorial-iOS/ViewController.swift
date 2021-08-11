//
//  ViewController.swift
//  QRCodeTutorial-iOS
//
//  Created by kimhyungyu on 2021/08/09.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var qrcodeButton: UIButton!
    @IBOutlet weak var addCardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardImageView.layer.cornerRadius = 10
        
        qrcodeButton.setPreferredSymbolConfiguration(.init(pointSize: 30,weight: .regular, scale: .default), forImageIn: .normal)
        
        addCardButton.imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 0)
    }

    @IBAction func presentToQRCodeModalViewController(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeModalViewController") as? QRCodeModalViewController else {
            return
        }
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func presentToQRCodeReaderViewController(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeReaderViewController") as? QRCodeReaderViewController else {
            return
        }
        nextVC.modalPresentationStyle = .currentContext
        present(nextVC, animated: true, completion: nil)
    }
}
