//
//  QRCodeView.swift
//  QRCodeTutorial-iOS
//
//  Created by kimhyungyu on 2021/08/09.
//

import Foundation
import UIKit

class QRCodeView: UIView {
    var filter = CIFilter(name: "CIQRCodeGenerator")
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    func generateCode(_ string: String, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
        guard let filter = filter, let data = string.data(using: .isoLatin1, allowLossyConversion: false) else {
            return
        }

        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        
        guard let ciImage = filter.outputImage else {
            return
        }
        // 선명하지 않다.
//        imageView.image = UIImage(ciImage: ciImage, scale: 2.0, orientation: .up)
        
//         qrcode 색 커스텀 가능하도록하고 선명하게 변환.
        let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
        let invertFilter = CIFilter(name: "CIColorInvert")
        invertFilter?.setValue(transformed, forKey: kCIInputImageKey)
        
        let alphaFilter = CIFilter(name: "CIMaskToAlpha")
        alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)
        
        if let ouputImage = alphaFilter?.outputImage {
            imageView.tintColor = foregroundColor
            imageView.backgroundColor = backgroundColor
            imageView.image = UIImage(ciImage: ouputImage, scale: 2.0, orientation: .up).withRenderingMode(.alwaysTemplate)
        } else {
            return
        }
        
    }
}
