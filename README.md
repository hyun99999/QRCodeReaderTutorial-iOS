# QRCodeReaderTutorial-iOS
๐ make QRcode and QRcode Reader Tutorial
QR์ฝ๋์ ๋ฆฌ๋๊ธฐ๋ฅผ ๋ง๋๋ ์คํ ๋ผ์ด๋ธ๋ฌ๋ฆฌ๊ฐ ์์ง๋ง ์์ฒด ๋ผ์ด๋ธ๋ฌ๋ฆฌ๋ฅผ ํ์ฉํด์ ๋ง๋ค์ด๋ณด๊ธฐ๋ก ํ๋ค.

# ๋ชฉ์ฐจ

- [QR์ฝ๋ ๋ง๋ค๊ธฐ](#qr์ฝ๋-๋ง๋ค๊ธฐ)
- [QR์ฝ๋ Reader ๋ง๋ค๊ธฐ](#qr์ฝ๋-reader-๋ง๋ค๊ธฐ)
- [์ํ๋ ์์ญ์์๋ง QR์ฝ๋ ์ฝ๊ธฐ](#์ํ๋-์์ญ์์๋ง-qr์ฝ๋-์ฝ๊ธฐ)

### ์์ฑ

<img src ="https://user-images.githubusercontent.com/69136340/128881724-a9c8aee5-74ff-488a-b6dc-dcccefb10ddb.gif" width ="250">

### Main.storyboard

ํ๋ฉด์ ๋ค์๊ณผ ๊ฐ์ด ๊ตฌ์ฑํ๋ค. ์ผ์ชฝ ์คํ ๋ฆฌ๋ณด๋๋ถํฐ 123 ์์.

- ViewController : (1) ๋ฉ์ธ ๋ทฐ์ปจํธ๋กค๋ฌ
- QRCodeModalViewController : (2) qr ์ฝ๋ ๋ฅผ ๋ง๋ค์ด์ ๋ชจ๋ฌ์ฐฝ์ผ๋ก ๋์ฐ๊ธฐ
- QRCodeReaderViewController : (3) qr ์ฝ๋ ๋ฆฌ๋๊ธฐ๋ฅผ ๋ง๋ค์ด์ ํ๋ฉด์ ํ

<img src ="https://user-images.githubusercontent.com/69136340/128881975-cb9bccfd-2729-45eb-9f35-70a5e4fa4bf4.png" width ="600">

---

# QR์ฝ๋ ๋ง๋ค๊ธฐ

CIQRCodeGenerator CIFilter ๋ฅผ ํตํด์ qr code ๋ฅผ ๋ง๋ค ๊ฒ์ด๋ค.

๊ฐ๋ฐ์ ๋ฌธ์๋ฅผ ์ดํด๋ณด์

[Apple Developer - Core Image Filter Reference(CIQRCodeGenerator)](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIQRCodeGenerator)

์ด ํํฐ๋ ๋๊ฐ์ง ํ๋ผ๋ฏธํฐ๋ฅผ ๊ฐ์ง๋ค.

- inputMessage : QR์ฝ๋๋ก ์ธ์ฝ๋ฉํ  ๋ฐ์ดํฐ์๋๋ค. NSData ๊ฐ์ฒด์๋๋ค.
- inputCorrectionLevel : ์ค๋ฅ ์์  ํ์์ ์ง์ ํ๋ ๋จ์ผ ๋ฌธ์์๋๋ค. NSString ๊ฐ์ฒด์๋๋ค. ๊ธฐ๋ณธ๊ฐ์ M.

String ๋๋ URL์์ QR ์ฝ๋๋ฅผ ์์ฑํ๋ ค๋ฉด NSISOLatin1StringEncoding ๋ฌธ์์ด ์ธ์ฝ๋ฉ์ ์ฌ์ฉํ์ฌ ์ด๋ฅผ NSData ๊ฐ์ฒด๋ก ๋ณํํฉ๋๋ค.

inputCorrectionLevel ๋งค๊ฐ๋ณ์๋ ์ค๋ฅ์์ ์ ์ํด์ ์ถ๋ ฅ์ด๋ฏธ์ง์ ์ธ์ฝ๋ฉ๋ ์ถ๊ฐ ๋ฐ์ดํฐ์์ ์ ์ดํฉ๋๋ค.

(QR์ฝ๋๋ ์ฝ๋์ ์ค์ผ์ด๋ ์์์๋ ์ฝ๋ ์์ฒด์ ๋ฐ์ดํฐ๋ฅผ ๋ณต์ํ๋ ๊ธฐ๋ฅ์ด ์์ต๋๋ค. ๋ ๋ฒจ์ ์ฌ๋ฆฌ๋ฉด ์ค๋ฅ๋ณต์ ๋ฅ๋ ฅ์ ํฅ์๋์ง๋ง ๋ฐ์ดํฐ๊ฐ ์ฆ๊ฐ๋์ด ์ฝ๋์ ํฌ๊ธฐ๊ฐ ์ปค์ง๋๋ค.)

- `L`: 7%
- `M`: 15%(๊ธฐ๋ณธ๊ฐ)
- `Q`: 25%
- `H`: 30%

qr code ์ ์ค๋ฅ ๋ณต์ ๊ธฐ๋ฅ์ ๋ํด์๋ ์๋ ์ฌ์ดํธ๋ฅผ ์ฐธ๊ณ ํด๋ณด์

[์ค๋ฅ ๋ณต์ ๊ธฐ๋ฅ์ ๋ํด](https://www.qrcode.com/ko/about/error_correction.html)

- QRCodeView.swift : QR code ๋ฅผ ๋ง๋๋ ํด๋์ค

```swift
import Foundation
import UIKit

class QRCodeView: UIView {

    // โ CIQRCodeGenerator : QR code ์์ฑ ํํฐ๋ฅผ ์๋ณํ๊ธฐ ์ํ ์์ฑ.
    var filter = CIFilter(name: "CIQRCodeGenerator")

    // โ QRCode CIImage ๋ฅผ ๋ง๋ค์ด์ ์ถ๊ฐํ  UIImageView.
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

    // โ QRCode ์ด๋ฏธ์ง๋ฅผ ๋ง๋ค ๋ ๋ค์ํ ์์ผ๋ก ๋ง๋ค ์ ์๋๋ก parameter ๋ฅผ ๋ฐ์๋ค.
    func generateCode(_ string: String, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
        
        // โ ์ฃผ์ด์ง ์ธ์ฝ๋ฉ์(=using) ์ฌ์ฉํด์ NSData ๊ฐ์ฒด๋ฅผ ๋ฐํํ๋ค.
        guard let filter = filter, let data = string.data(using: .isoLatin1, allowLossyConversion: false) else {
            return
        }
        
        // โ ๋๊ฐ์ง ํ๋ผ๋ฏธํฐ ์ค์ .
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")

        // โ .outputImage : ํํฐ์ ๊ตฌ์ฑ๋ ์์์ ์บก์ํํ๋ CIImage ๊ฐ์ฒด์ด๋ค. ์ฆ, ๊ฒฐ๊ณผ๋ฌผ
        guard let ciImage = filter.outputImage else {
            return
        }

        // โ๏ธ ์ด๋ ๊ฒ ๋๋ด๋ฉด qr code ๊ฐ ์ ๋ชํ์ง ์๊ฒ ๋์จ๋ค.
        //imageView.image = UIImage(ciImage: ciImage, scale: 2.0, orientation: .up)
        
        // โ ๋ค์์ ์ด๋ฏธ์ง ์ ๋ชํ๊ฒ ๋ณํํ๋ ๊ณผ์ ์ด๋ค.
        // โ ์๋ ์ด๋ฏธ์ง์ affine transform(by ํ๋ผ๋ฏธํฐ๋ฅผ ์๋ฏธ.) ์ ์ ์ฉํ ์ ์ด๋ฏธ์ง๋ฅผ ๋ฐํ. ์ด๋ฏธ์ง์ ๋์ด์ ๋์ด๋ฅผ 10๋ฐฐ ์ฆ๊ฐ์ํด.
        let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
        
        // โ ๋ค์์ QR code ์ ์ปค์คํ ์ค์ ํ๋ ๊ณผ์ ์ด๋ค. ํํฐ ์์ฑํ๊ณ  ์ด๋ฏธ์ง ์ ์ฉ.
        // โ CIColorInvert : ์์์ ๋ฐ์ ์ํค๊ธฐ ์ํ ํํฐ์ด๋ค.
        let invertFilter = CIFilter(name: "CIColorInvert")
        invertFilter?.setValue(transformed, forKey: kCIInputImageKey)

        // โ CIMaskToAlpha : grayscale ๋ก ๋ณํ๋ ์ด๋ฏธ์ง๋ฅผ alpha ๋ก ๋ง์คํน๋ ํฐ์์ด๋ฏธ์ง๋ก ๋ณํ.
        let alphaFilter = CIFilter(name: "CIMaskToAlpha")
        alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)
        
        // โ ๋ฐ์ ํ๋ผ๋ฏธํฐ๋ก imageView ์ ์์ฑ์ ์ค์ . 
        if let ouputImage = alphaFilter?.outputImage {
            imageView.tintColor = foregroundColor
            imageView.backgroundColor = backgroundColor

            // โ withRenderingMode(.alwaysTemplate) : ์๋ณธ ์ด๋ฏธ์ง์ ์ปฌ๋ฌ์ ๋ณด๊ฐ ์ฌ๋ผ์ง๊ณ  ๋ถํฌ๋ชํ ๋ถ๋ถ์ tintColor ๋ก ์ค์ .
            imageView.image = UIImage(ciImage: ouputImage, scale: 2.0, orientation: .up).withRenderingMode(.alwaysTemplate)
        } else {
            return
        }
    }
}
```

- โ CIColorInvert : ์์์ ๋ฐ์ ์ํค๊ธฐ ์ํ ํํฐ์ด๋ค.

<img width="500" alt="2-1" src="https://user-images.githubusercontent.com/69136340/128882210-8158868e-4fd2-466e-aa8a-ed2fc02828b9.png">

- โ CIMaskToAlpha : grayscale ๋ก ๋ณํ๋ ์ด๋ฏธ์ง๋ฅผ alpha ๋ก ๋ง์คํน๋ ํฐ์์ด๋ฏธ์ง๋ก ๋ณํ.

<img width="500" alt="2" src="https://user-images.githubusercontent.com/69136340/128882227-d23b6398-5de7-4d08-99d7-49bdc8b76a60.png">

- QRCodeModalViewController.swift

QRCodeView ํด๋์ค๋ฅผ ํตํด์ qr code ๋ฅผ ๋ง๋ค์ด๋ณด์.

```swift
class QRCodeModalViewController: UIViewController {

    @IBOutlet weak var qrcodeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(origin: .zero, size: qrcodeView.frame.size)
        let qrcode = QRCodeView(frame: frame)

        // โ ๋ด ๊นํ๋ธ ์ฃผ์ ๋ฌธ์์ด์ data ๋ก ๊ฐ์ง๋ qr code.
        qrcode.generateCode("https://github.com/hyun99999", foregroundColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), backgroundColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        
        qrcodeView.addSubview(qrcode)
    }
}
```

### ๊ฒฐ๊ณผ

<img src ="https://user-images.githubusercontent.com/69136340/128903060-70a0b409-20e2-4fc9-a253-84bd405c331e.png" width ="250">

---

์ฐธ๊ณ :

[Swift QRcode make](https://kodaewon.github.io/ios/2018/10/15/ios-qrcode/)

[iOS์์ QR ์ฝ๋๋ฅผ ์์ฑํ๋ ๋ฐฉ๋ฒ](https://ichi.pro/ko/ioseseo-qr-kodeuleul-saengseonghaneun-bangbeob-266413765452800)

[Apple Developer - Core Image Filter Reference(CIFilter)](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci)

# QR์ฝ๋ Reader ๋ง๋ค๊ธฐ

### ์นด๋ฉ๋ผ ๊ถํ ์ป๊ธฐ

- info.plist ์ ์ถ๊ฐํ๋ค.

<img src ="https://user-images.githubusercontent.com/69136340/128959662-ae0f3cef-2472-4c6c-aefd-c6511b7744bb.png" width ="600">

### [AVCaptureSession](https://developer.apple.com/documentation/avfoundation/avcapturesession/)

๊ฐ๋ฐ์ ๋ฌธ์๋ฅผ ์ดํด๋ณด์

์บก์ฒ ํ๋์ ๊ด๋ฆฌํ๊ณ  ์๋ ฅ ์ฅ์น์ ๋ฐ์ดํฐ ํ๋ฆ์ ์กฐ์ ํ์ฌ ์ถ๋ ฅ์ ์บก์ฒํ๋ ๊ฐ์ฒด์๋๋ค.

**overview**

์ค์๊ฐ ์บก์ฒ๋ฅผ ์ํํ๋ ค๋ฉด AVCaptureSession ๊ฐ์ฒด๋ฅผ ์ธ์คํด์คํํ๊ณ  ์ ์ ํ inputs ๋ฐ outputs ๋ฅผ ์ถ๊ฐํฉ๋๋ค.

`startRunning()` ์ ํธ์ถํ์ฌ input ์์ output ์ผ๋ก์ ๋ฐ์ดํฐ ํ๋ฆ์ ์์ํ๊ณ  `stopRunning()`์ ํธ์ถํ์ฌ ํ๋ฆ์ ์ค์งํฉ๋๋ค.

`startRunning()` ๋ฉ์๋๋ ์๊ฐ์ด ๊ฑธ๋ฆฌ๋ blocking call ์ด๋ฏ๋ก main queue ๊ฐ ์ฐจ๋จ๋์ง ์๋๋ก serial queue ์์ ์ธ์ ์ค์ ์ ์ํํด์ผ ํฉ๋๋ค. (UI ๋ฅผ ๋ฐ์์ ์ผ๋ก ์ ์งํ๊ฒ ํด์ค๋ค.)

[`seesionPreset`](https://developer.apple.com/documentation/avfoundation/avcapturesession/1389696-sessionpreset) ์์ฑ์ ์ฌ์ฉํด์ ์ถ๋ ฅ์ ๋ํ ํ์ง ์์ค, ๋นํธ ์ ์ก๋ฅ  ๋๋ ๊ธฐํ ์ค์ ์ ์ฌ์ฉ์ ์ง์ ํฉ๋๋ค.(๊ธฐ๋ณธ๊ฐ์ high ์๋๋ค.

- ์ ๋ฐ์ ์ธ ์์์ metadata ์ ๋ํด์ ๋จผ์  ์์๋ณด์

1๏ธโฃ  AVCaptureSession ๊ฐ์ฒด๋ฅผ ์ธ์คํด์คํ

2๏ธโฃ  ์ ์ ํ inputs ์ค์ 

3๏ธโฃ  ์ ์ ํ ouputs ์ค์ 

4๏ธโฃ `startRunning()` ๊ณผ `stopRunning()` ๋ก ํ๋ฆ ํต์ 

[metadata](https://developer.apple.com/documentation/avfoundation/avcapturephotosettings/2875951-metadata) : ์ฌ์ง ํ์ผ output ์ ํฌํจํ  metadata keys ์ values ์ ๋์๋๋ฆฌ. 

์ฆ, ์ฌ๊ธฐ์๋ photo ๋ฐ์ดํฐ์ ๋ํ ๋ฐ์ดํฐ๋ฅผ ์๋ฏธํ๋ค.

- QRCodeReaderViewController : QR์ฝ๋ reader ๋ฅผ ์ถ๊ฐํ๊ณ  ์ฝ์ ์ ๋ณด๋ฅผ ๋ค๋ฃจ๋ ๋ทฐ์ปจํธ๋กค๋ฌ

```swift
import UIKit
import AVFoundation

class QRCodeReaderViewController: UIViewController {

    // 1๏ธโฃ ์ค์๊ฐ ์บก์ฒ๋ฅผ ์ํํ๊ธฐ ์ํด์ AVCaptureSession ๊ฐ์ฒด๋ฅด ์ธ์คํด์คํ.
    private let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicSetting()
    }
    
}
extension QRCodeReaderViewController {
    
    private func basicSetting() {
        
        // โ AVCaptureDevice : capture sessions ์ ๋ํ ์๋ ฅ(audio or video)๊ณผ ํ๋์จ์ด๋ณ ์บก์ฒ ๊ธฐ๋ฅ์ ๋ํ ์ ์ด๋ฅผ ์ ๊ณตํ๋ ์ฅ์น.
        // โ ์ฆ, ์บก์ฒํ  ๋ฐฉ์์ ์ ํ๋ ์ฝ๋.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
        
        // โ ์๋ฎฌ๋ ์ดํฐ์์๋ ์นด๋ฉ๋ผ๋ฅผ ์ฌ์ฉํ  ์ ์๊ธฐ ๋๋ฌธ์ ์๋ฎฌ๋ ์ดํฐ์์ ์คํํ๋ฉด ์๋ฌ๊ฐ ๋ฐ์ํ๋ค.          
        fatalError("No video device found")
        }
        do {

            // 2๏ธโฃ ์ ์ ํ inputs ์ค์ 
            // โ AVCaptureDeviceInput : capture device ์์ capture session ์ผ๋ก media ๋ฅผ ์ ๊ณตํ๋ capture input. 
            // โ ์ฆ, ํน์  device ๋ฅผ ์ฌ์ฉํด์ input ๋ฅผ ์ด๊ธฐํ.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // โ session ์ ์ฃผ์ด์ง input ๋ฅผ ์ถ๊ฐ.
            captureSession.addInput(input)
            
            // 3๏ธโฃ ์ ์ ํ outputs ์ค์ 
            // โ AVCaptureMetadataOutput : capture session ์ ์ํด์ ์์ฑ๋ ์๊ฐ์ ํ metadata ๋ฅผ ์ฒ๋ฆฌํ๊ธฐ ์ํ capture output.
            // โ ์ฆ, ์์์ผ๋ก ์ดฌ์ํ๋ฉด์ ์ง์์ ์ผ๋ก ์์ฑ๋๋ metadata ๋ฅผ ์ฒ๋ฆฌํ๋ output ์ด๋ผ๋ ๋ง.
            let output = AVCaptureMetadataOutput()

            // โ session ์ ์ฃผ์ด์ง output ๋ฅผ ์ถ๊ฐ.
            captureSession.addOutput(output)

            // โ AVCaptureMetadataOutputObjectsDelegate ํฌ๋กํ ์ฝ์ ์ฑํํ๋ delegate ์ dispatch queue ๋ฅผ ์ค์ ํ๋ค.
            // โ queue : delegate ์ ๋ฉ์๋๋ฅผ ์คํํ  ํ์ด๋ค. ์ด ํ๋ metadata ๊ฐ ๋ฐ์ ์์๋๋ก ์ ๋ฌ๋๋ ค๋ฉด ๋ฐ๋์ serial queue(์ง๋ ฌํ) ์ฌ์ผ ํ๋ค.     
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // โ ๋ฆฌ๋๊ธฐ๊ฐ ์ธ์ํ  ์ ์๋ ์ฝ๋ ํ์์ ์ ํ๋ค. ์ด ํ๋ก์ ํธ์ ๊ฒฝ์ฐ qr.
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

            // โ ์นด๋ฉ๋ผ ์์์ด ๋์ค๋ layer ์ + ๋ชจ์ ๊ฐ์ด๋ ๋ผ์ธ์ ๋ทฐ์ ์ถ๊ฐํ๋ ํจ์ ํธ์ถ.           
            setVideoLayer()
            setGuideCrossLineView()
            
            // 4๏ธโฃ startRunning() ๊ณผ stopRunning() ๋ก ํ๋ฆ ํต์ 
            // โ input ์์ output ์ผ๋ก์ ๋ฐ์ดํฐ ํ๋ฆ์ ์์
            captureSession.startRunning()
        }
        catch {
            print("error")
        }
    }

    // โ ์นด๋ฉ๋ผ ์์์ด ๋์ค๋ layer ๋ฅผ ๋ทฐ์ ์ถ๊ฐ
    private func setVideoLayer() {
        // ์์์ ๋ด์ ๊ณต๊ฐ.
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // ์นด๋ฉ๋ผ์ ํฌ๊ธฐ ์ง์ 
        videoLayer.frame = view.layer.bounds
        // ์นด๋ฉ๋ผ์ ๋น์จ์ง์ 
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
    }

    // โ + ๋ชจ์ ๊ฐ์ด๋๋ผ์ธ์ ๋ทฐ์ ์ถ๊ฐ
    private func setGuideCrossLineView() {
        let guideCrossLine = UIImageView()
        guideCrossLine.image = UIImage(systemName: "plus")
        guideCrossLine.tintColor = .green
        guideCrossLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guideCrossLine)
        NSLayoutConstraint.activate([
            guideCrossLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideCrossLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            guideCrossLine.widthAnchor.constraint(equalToConstant: 30),
            guideCrossLine.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

// โ metadata capture ouput ์์ ์์ฑ๋ metatdata ๋ฅผ ์์ ํ๋ ๋ฉ์๋.
// โ ์ด ํ๋กํ ์ฝ์ ์์์์ฒ๋ผ AVCaptureMetadataOutput object ๊ฐ ์ฑํํด์ผ๋ง ํ๋ค. ๋จ์ผ ๋ฉ์๋๊ฐ ์๊ณ  ์ต์์ด๋ค.
// โ ์ด ๋ฉ์๋๋ฅผ ์ฌ์ฉํ๋ฉด capture metadata ouput object ๊ฐ connection ์ ํตํด์ ๊ด๋ จ๋ metadata objects ๋ฅผ ์์ ํ  ๋ ์๋ตํ  ์ ์๋ค.(์๋ ๋ฉ์๋์ ํ๋ผ๋ฏธํฐ๋ฅผ ํตํด ๋ค๋ฃฐ ์ ์๋ค.)
// โ ์ฆ, ์ด ํ๋กํ ์ฝ์ ํตํด์ metadata ๋ฅผ ์์ ํด์ ๋ฐ์ํ  ์ ์๋ค.
extension QRCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {

    // โ caputure output object ๊ฐ ์๋ก์ด metadata objects ๋ฅผ ๋ณด๋์ ๋ ์๋ฆฐ๋ค.
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        // โ metadataObjects : ์๋ก ๋ด๋ณด๋ธ AVMetadataObject ์ธ์คํด์ค ๋ฐฐ์ด์ด๋ค.
        if let metadataObject = metadataObjects.first {

            // โ AVMetadataObject ๋ ์ถ์ ํด๋์ค์ด๋ฏ๋ก ์ด ๋ฐฐ์ด์ object ๋ ํญ์ ๊ตฌ์ฒด์ ์ธ ํ์ ํด๋์ค์ ์ธ์คํด์ค์ฌ์ผ ํ๋ค.
            // โ AVMetadataObject ๋ฅผ ์ง์  ์๋ธํด๋์ฑํด์  ์๋๋ค. ๋์  AVFroundation ํ๋ ์์ํฌ์์ ์ ๊ณตํ๋ ์ ์๋ ํ์ ํด๋์ค ์ค ํ๋๋ฅผ ์ฌ์ฉํด์ผ ํ๋ค.
            // โ AVMetadataMachineReadableCodeObject : ๋ฐ์ฝ๋์ ๊ธฐ๋ฅ์ ์ ์ํ๋ AVMetadataObject ์ ๊ตฌ์ฒด์ ์ธ ํ์ ํด๋์ค. ์ธ์คํด์ค๋ ์ด๋ฏธ์ง์์ ๊ฐ์ง๋ ํ๋ ๊ฐ๋ฅํ ๋ฐ์ฝ๋์ ๊ธฐ๋ฅ๊ณผ payload ๋ฅผ ์ค๋ชํ๋ immutable object ๋ฅผ ๋ํ๋ธ๋ค.
            // โ (์ฐธ๊ณ ๋ก ์ด์ธ์๋ AVMetadataFaceObject ๋ผ๋ ๊ฐ์ง๋ ๋จ์ผ ์ผ๊ตด์ ๊ธฐ๋ฅ์ ์ ์ํ๋ subclass ๋ ์๋ค.)
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }

            // โ qr์ฝ๋๊ฐ ๊ฐ์ง ๋ฌธ์์ด์ด URL ํํ๋ฅผ ๋๋ค๋ฉด ์ถ๋ ฅ.(์๋ฌด๋ฐ qr์ฝ๋๋ ์ฐ๋๋ค๊ณ  ์ถ๋ ฅ์ํค๋ฉด ์๋๋๊น ์ฌ๊ธฐ์ ๋ถ๊ธฐ์ฒ๋ฆฌ ๊ฐ๋ฅ. )
            if stringValue.hasPrefix("http://") || stringValue.hasPrefix("https://")  {
                print(stringValue)

                // 4๏ธโฃ startRunning() ๊ณผ stopRunning() ๋ก ํ๋ฆ ํต์ 
                // โ input ์์ output ์ผ๋ก์ ํ๋ฆ ์ค์ง
                self.captureSession.stopRunning()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
```

### ๊ฒฐ๊ณผ

<img src ="https://user-images.githubusercontent.com/69136340/128881724-a9c8aee5-74ff-488a-b6dc-dcccefb10ddb.gif" width ="250">

### ์๊ฐํด๋ณผ ์ 

์์ QR์ฝ๋ ํด๋์ค๋ฅผ ๋ง๋ค์ด์ ์ฌ์ฉํ๋ ๋ฐ๋ฉด QR์ฝ๋ reader ๋ ์ ๋ณด๋ฅผ ์ฝ๊ณ  ๋ค๋ค์ผ ํ๋ ๊ธฐ๋ฅ์ ์ข ๋ ์ง์คํด๋ณด๊ธฐ ์ํด์ ํธ์์ ๋ทฐ์ปจํธ๋กค๋ฌ์์ ๋ค๋ฃจ์ด ์ฃผ์๋ค.

์๋์ ๋ธ๋ก๊ทธ๋ฅผ ์ฐธ๊ณ ํ๋ฉด reader ๋ฅผ ํด๋์ค๋ก ๋ง๋ค ์ ์๋ค. ํด๋์ค๋ก ๋ง๋ค์์ ๋ ์ฐ๋ฆฌ๊ฐ ๊ณ ๋ คํด์ผํ๋ ์ ์ ๋ทฐ์ปจํธ๋กค๋ฌ์ QR์ฝ๋๋ฅผ ์ฝ์ ๊ฒฐ๊ณผ๋ฅผ ์ ๋ฌํ  delegate ๋ง๋ค๊ณ  ๋ทฐ์ปจํธ๋กค๋ฌ์์ ๊ทธ delegate ๋ฅผ ์ฒ๋ฆฌํ๋ ๋ถ๋ถ์ ๊ตฌํํด์ผ ํ๋ ๊ฒ์ด๋ค.

[QR, Barcode ๋ฆฌ๋๊ธฐ ๋ง๋ค๊ธฐ - ๋๋(swieeft)์ ๊ฐ๋ฐ์๋ฐ๊ธฐ](https://swieeft.github.io/2020/02/25/QRCodeAndBarcodeReader.html)

์ฐธ๊ณ  :

[[iOS] QR Code Scanner ๋ง๋ค๊ธฐ - AvFoundation ์ด์ฉ](https://dongminyoon.tistory.com/19)

[IOS) QRCode ๋ฆฌ๋๊ธฐ ๋ง๋ค๊ธฐ](https://hururuek-chapchap.tistory.com/34)

---
# ์ํ๋ ์์ญ์์๋ง QR์ฝ๋ ์ฝ๊ธฐ

์ฐ๋ฆฌ๊ฐ ์ ํ๋ QR์ฝ๋ ๋ฆฌ๋๊ธฐ๋ ํน์  ์์ญ์์์ QR์ฝ๋๊ฐ ์ฝํ๋ค. ๊ทธ ์ด์ ๋ก ๋๋ ๋ง์ QR์ฝ๋๊ฐ ์นด๋ฉ๋ผ์ ์กํ์ง ์๋๋ก ์ฌ์ฉ์๋ฅผ ์ ๋ํจ๊ณผ ๋์์ ์ฌ์ฉ์๊ฐ ๋ณธ์ธ์ QR์ฝ๋๋ฅผ ์๋ ฅํ๋ ์ธ์์ ์ฃผ๊ธฐ ์ํจ์ด๋ผ๊ณ  ์๊ฐ์ด ๋ ๋ค. ํธ๋ํฐ์ ์ ๋๋ก ๊ฐ์ ธ๋ค ๋์ง๋ ์์๋๋ฐ ์กฐ๊ธ์ด๋ผ๋ ์นด๋ฉ๋ผ์ ๋ธ์ถ๋ QR์ฝ๋๊ฐ ๋ฐ๋ก ์ฝํ๋ค๋ฉด ์ฌ์ฉ์๋ ๋ถ๋ช ๋นํฉ์ค๋ฌ์ธ ๊ฒ์ด๋ค.

๊ทธ๋์ ์ด๋ฐ ์ด์ ๋ก QR์ฝ๋ ์์ญ์ ์ง์ ํ๋ ๊ฒ์ ํด๋ณด๋ ค ํ๋ค.

- `AVCaputureMetadataOutput` ์ `rectOfInterest` ์์ฑ์ ์ด์ฉํ๋ฉด ๋๋ค. ๋จผ์  ๊ฐ๋ฐ์ ๋ฌธ์๋ฅผ ์ดํด๋ณด์.

### [rectOfInterest](https://developer.apple.com/documentation/avfoundation/avcapturemetadataoutput/1616291-rectofinterest/)

- ์๊ฐ์  metatdata ์ ๊ฒ์ ์์ญ์ ์ ํํ๊ธฐ ์ํ ์ฌ๊ฐํ์ ๊ฒฐ์ ํ๋ `CGRect` ๊ฐ์ด๋ค.
- ์ฌ๊ฐํ์ origin(์์ ) ์ ์ผ์ชฝ ์๋จ์ด๊ณ  metatdat ๋ฅผ ์ ๊ณตํ๋ ์ฅ์น์ ์ขํ๊ณต๊ฐ์ ๊ธฐ์ค์ผ๋ก ํ๋ค.
- rectangle of interest ๋ฅผ ์ง์ ํ๋ฉด ํน์  ์ ํ์ metadata ์ ๋ํ ๊ฐ์ง ๋ฅ๋ ฅ์ด ํฅ์๋  ์ ์๋ค. `rectOfInterest` ๋ฅผ ๊ฐ๋ก์ง๋ฅด๋ metadata ojects ์ bounds ๊ฐ ์๋๋ฉด ๋ฆฌํดํ์ง ์๋๋ค.(์ฆ ์ฌ๊ฐํ์์ ์์ง ์์ผ๋ฉด ์ธ์ํ์ง ์๋๋ค๋ ๋ง.)
- ๊ธฐ๋ณธ๊ฐ์ (0.0, 0.0, 1.0, 1.0) ์ด๋ค.

**๊ธฐ๋ณธ๊ฐ์ด....? ์กฐ๊ธ ์ด์ํ๋ค. width ์ height ์ ๊ธฐ๋ณธ๊ฐ์ด 1.0 ์ด๋ผ.. ์ค์ ๋ก ๊ฐ์ ๋์ค์ ์ถ๋ ฅํด๋ณด๋ฉด ์๊ฒ ์ง๋ง 0~100% ๊น์ง  ๋น์จ์ ํ๋ ์์ ์ฑ์ด๋ค๊ณ  ํ๋ค. ๊ทธ๋์ ์๋ฌด๋ฐ ์์ฑ์ค์  ์๋ ๊ธฐ๋ณธ๊ฐ์์๋ ์ ์ฒด ํ๋ ์์์ qr์ฝ๋๋ฅผ ์ธ์ํ์๋ค.**

๊ทธ๋์ ์ฐ๋ฆฌ๋  `metadataOutputRectConverted` ๋ฅผ ์ฌ์ฉํด์ ๋น์จ๋ก ๋ณํํด์ฃผ์ด์ผ ํ๋ค.

### [metadataOutputRectConverted](https://developer.apple.com/documentation/avfoundation/avcapturevideopreviewlayer/1623495-metadataoutputrectconverted)

- preview layer(์ฌ๊ธฐ์๋ AVCaptureVideoPreviewLayer ๊ฐ์ฒด์ ํด๋น) ์ metadata ouputs ์ ์ฌ์ฉ๋๋ ์ขํ๊ณ์ ์ฌ๊ฐํ์ผ๋ก ๋ณํ.

`+`  ๋ชจ์์ด์๋ ๊ฐ์ด๋ ๋ผ์ธ์์ **์ ์ฌ๊ฐํ์ ๊ฐ์ด๋๋ผ์ธ์ ๋ณด์ฌ์ฃผ๊ณ  ๊ฑฐ๊ธฐ์๋ง QR์ฝ๋๊ฐ ์ฝํ๋๋ก ํด๋ณด์.** 

๊ฐ์ด๋๋ผ์ธ์ ๊ทธ๋ฆฌ๋ ์์์ ์ต๊ทผ์ ์ฝ์๋ zedd ๋์ UIBezierPath ์ ๊ดํ ๊ธ์ ์ฝ์ด๋ดค๊ณ  ํ์ฉํด๋ณด๊ธฐ๋ก ํ๋ค.

[iOS ) UIBezierPath (3) - Triangle, Circle](https://zeddios.tistory.com/822?category=682195)

### ์์ฑ

<img src ="https://user-images.githubusercontent.com/69136340/129237145-666742e1-5769-4578-9ff5-05adebfde216.gif" width ="250">

### ์ฝ๋

- QRCodeReaderViewController.swift

โ **์์ญ ์ ํ**

```swift
extension QRCodeReaderViewController {
    
    private func basicSetting() {
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        do {
            // โ ์ ํํ๊ณ  ์ถ์ ์์ญ
            let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2 , y: (UIScreen.main.bounds.height - 200) / 2, width: 200, height: 200)
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // โ preview layer ์์์ ์์ญ ๋ณํ๊ฐ์ ๋ฆฌํด๋ฐ์ ์ฌ์ฉํ๊ธฐ ์ํด์ ๊ธฐ์กด ์ฝ๋์์ ์์ ํด์ฃผ์๋ค.
            let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)

            // โ rectOfInterest ๋ฅผ ์ค์ (=์ ํ์์ญ ์ค์  ์๋ฃ)
            output.rectOfInterest = rectConverted

            // โ ์ ์ฌ๊ฐํ ๊ฐ์ด๋ ๋ผ์ธ ์ถ๊ฐ
            setGuideCrossLineView(rectOfInterest: rectOfInterest)
            
            captureSession.startRunning()
        }
        catch {
            print("error")
        }
    }
    
    // โ preview layer ์์์ ์์ญ ๋ณํ๊ฐ์ ๋ฆฌํด๋ฐ์ ์ฌ์ฉํ๊ธฐ ์ํด์ ๊ธฐ์กด ์ฝ๋์์ ์์ ํด์ฃผ์๋ค.
    private func setVideoLayer(rectOfInterest: CGRect) -> CGRect{
        // ์์์ ๋ด์ ๊ณต๊ฐ.
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //์นด๋ฉ๋ผ์ ํฌ๊ธฐ ์ง์ 
        videoLayer.frame = view.layer.bounds
        //์นด๋ฉ๋ผ์ ๋น์จ์ง์ 
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        
        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }

    private func setGuideCrossLineView(rectOfInterest: CGRect) { 
    //...
    }
}
```

โ **๊ฐ์ด๋๋ผ์ธ ์ถ๊ฐ**

```swift
extension QRCodeReaderViewController {

    // ...

    private func setGuideCrossLineView(rectOfInterest: CGRect) {

        // ์๋ต๋ ์ฝ๋๋ + ๋ชจ์ ๊ฐ์ด๋๋ผ์ธ ์ถ๊ฐ ์ฝ๋์ด๋ค.
        // ...
        
        let cornerLength: CGFloat = 20
        let cornerLineWidth: CGFloat = 5
        
        // โ ๊ฐ์ด๋๋ผ์ธ์ ๊ฐ ๋ชจ์๋ฆฌ point
        let upperLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.minY)
        let upperRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.minY)
        let lowerRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.maxY)
        let lowerLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.maxY)
        
        // โ ๊ฐ ๋ชจ์๋ฆฌ๋ฅผ ์ค์ฌ์ผ๋ก ํ Edge๋ฅผ ๊ทธ๋ฆผ.
        let upperLeftCorner = UIBezierPath()
        upperLeftCorner.lineWidth = cornerLineWidth
        upperLeftCorner.move(to: CGPoint(x: upperLeftPoint.x + cornerLength, y: upperLeftPoint.y))
        upperLeftCorner.addLine(to: CGPoint(x: upperLeftPoint.x, y: upperLeftPoint.y))
        upperLeftCorner.addLine(to: CGPoint(x: upperLeftPoint.x, y: upperLeftPoint.y + cornerLength))
        
        let upperRightCorner = UIBezierPath()
        upperRightCorner.lineWidth = cornerLineWidth
        upperRightCorner.move(to: CGPoint(x: upperRightPoint.x - cornerLength, y: upperRightPoint.y))
        upperRightCorner.addLine(to: CGPoint(x: upperRightPoint.x, y: upperRightPoint.y))
        upperRightCorner.addLine(to: CGPoint(x: upperRightPoint.x, y: upperRightPoint.y + cornerLength))
        
        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.lineWidth = cornerLineWidth
        lowerRightCorner.move(to: CGPoint(x: lowerRightPoint.x, y: lowerRightPoint.y - cornerLength))
        lowerRightCorner.addLine(to: CGPoint(x: lowerRightPoint.x, y: lowerRightPoint.y))
        lowerRightCorner.addLine(to: CGPoint(x: lowerRightPoint.x - cornerLength, y: lowerRightPoint.y))
        
        let lowerLeftCorner = UIBezierPath()
        lowerLeftCorner.lineWidth = cornerLineWidth
        lowerLeftCorner.move(to: CGPoint(x: lowerLeftPoint.x + cornerLength, y: lowerLeftPoint.y))
        lowerLeftCorner.addLine(to: CGPoint(x: lowerLeftPoint.x, y: lowerLeftPoint.y))
        lowerLeftCorner.addLine(to: CGPoint(x: lowerLeftPoint.x, y: lowerLeftPoint.y - cornerLength))
        
        upperLeftCorner.stroke()
        upperRightCorner.stroke()
        lowerRightCorner.stroke()
        lowerLeftCorner.stroke()
        
        // โ layer ์ ์ถ๊ฐ
        
        let upperLeftCornerLayer = CAShapeLayer()
        upperLeftCornerLayer.path = upperLeftCorner.cgPath
        upperLeftCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
        upperLeftCornerLayer.fillColor = UIColor.clear.cgColor
        upperLeftCornerLayer.lineWidth = cornerLineWidth
        
        let upperRightCornerLayer = CAShapeLayer()
        upperRightCornerLayer.path = upperRightCorner.cgPath
        upperRightCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
        upperRightCornerLayer.fillColor = UIColor.clear.cgColor
        upperRightCornerLayer.lineWidth = cornerLineWidth
        
        let lowerRightCornerLayer = CAShapeLayer()
        lowerRightCornerLayer.path = lowerRightCorner.cgPath
        lowerRightCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
        lowerRightCornerLayer.fillColor = UIColor.clear.cgColor
        lowerRightCornerLayer.lineWidth = cornerLineWidth
 
        let lowerLeftCornerLayer = CAShapeLayer()
        lowerLeftCornerLayer.path = lowerLeftCorner.cgPath
        lowerLeftCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
        lowerLeftCornerLayer.fillColor = UIColor.clear.cgColor
        lowerLeftCornerLayer.lineWidth = cornerLineWidth
        
        view.layer.addSublayer(upperLeftCornerLayer)
        view.layer.addSublayer(upperRightCornerLayer)
        view.layer.addSublayer(lowerRightCornerLayer)
        view.layer.addSublayer(lowerLeftCornerLayer)
    }
}
```

**์ฐธ๊ณ  : **
[[iOS] Swift QRCode ์ฝ๊ธฐ](https://nebori.tistory.com/28)

