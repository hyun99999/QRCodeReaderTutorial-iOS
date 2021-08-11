# QRCodeReaderTutorial-iOS
🏁 make QRcode and QRcode Reader Tutorial

QR코드와 리더기를 만드는 오픈 라이브러리가 있지만 자체 라이브러리를 활용해서 만들어보기로 했다.

# 목차

- [QR코드 만들기](#qr코드-만들기)
- [QR코드 Reader 만들기](#qr코드-reader-만들기)

### 완성

<img src ="https://user-images.githubusercontent.com/69136340/128881724-a9c8aee5-74ff-488a-b6dc-dcccefb10ddb.gif" width ="250">

### Main.storyboard

화면은 다음과 같이 구성했다. 왼쪽 스토리보드부터 123 순서.

- ViewController : (1) 메인 뷰컨트롤러
- QRCodeModalViewController : (2) qr 코드 를 만들어서 모달창으로 띄우기
- QRCodeReaderViewController : (3) qr 코드 리더기를 만들어서 화면전환

<img src ="https://user-images.githubusercontent.com/69136340/128881975-cb9bccfd-2729-45eb-9f35-70a5e4fa4bf4.png" width ="600">

---

# QR코드 만들기

CIQRCodeGenerator CIFilter 를 통해서 qr code 를 만들 것이다.

개발자 문서를 살펴보자

[Apple Developer - Core Image Filter Reference(CIQRCodeGenerator)](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIQRCodeGenerator)

이 필터는 두가지 파라미터를 가진다.

- inputMessage : QR코드로 인코딩할 데이터입니다. NSData 개체입니다.
- inputCorrectionLevel : 오류 수정 형식을 지정하는 단일 문자입니다. NSString 개체입니다. 기본값은 M.

String 또는 URL에서 QR 코드를 생성하려면 NSISOLatin1StringEncoding 문자열 인코딩을 사용하여 이를 NSData 객체로 변환합니다.

inputCorrectionLevel 매개변수는 오류수정을 위해서 출력이미지에 인코딩된 추가 데이터양을 제어합니다.

(QR코드는 코드의 오염이나 손상에도 코드 자체에 데이터를 복원하는 기능이 있습니다. 레벨을 올리면 오류복원 능력은 향상되지만 데이터가 증가되어 코드의 크기가 커집니다.)

- `L`: 7%
- `M`: 15%(기본값)
- `Q`: 25%
- `H`: 30%

qr code 의 오류 복원 기능에 대해서는 아래 사이트를 참고해보자

[오류 복원 기능에 대해](https://www.qrcode.com/ko/about/error_correction.html)

- QRCodeView.swift : QR code 를 만드는 클래스

```swift
import Foundation
import UIKit

class QRCodeView: UIView {

    // ✅ CIQRCodeGenerator : QR code 생성 필터를 식별하기 위한 속성.
    var filter = CIFilter(name: "CIQRCodeGenerator")

    // ✅ QRCode CIImage 를 만들어서 추가할 UIImageView.
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

    // ✅ QRCode 이미지를 만들 때 다양한 색으로 만들 수 있도록 parameter 를 받았다.
    func generateCode(_ string: String, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
        
        // ✅ 주어진 인코딩을(=using) 사용해서 NSData 개체를 반환한다.
        guard let filter = filter, let data = string.data(using: .isoLatin1, allowLossyConversion: false) else {
            return
        }
        
        // ✅ 두가지 파라미터 설정.
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")

        // ✅ .outputImage : 필터에 구성된 작업을 캡슐화하는 CIImage 개체이다. 즉, 결과물
        guard let ciImage = filter.outputImage else {
            return
        }

        // ❗️ 이렇게 끝내면 qr code 가 선명하지 않게 나온다.
        //imageView.image = UIImage(ciImage: ciImage, scale: 2.0, orientation: .up)
        
        // ✅ 다음은 이미지 선명하게 변환하는 과정이다.
        // ✅ 원래 이미지에 affine transform(by 파라미터를 의미.) 을 적용한 새 이미지를 반환. 이미지의 넓이와 높이를 10배 증가시킴.
        let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
        
        // ✅ 다음은 QR code 색 커스텀 설정하는 과정이다. 필터 생성하고 이미지 적용.
        // ✅ CIColorInvert : 색상을 반전시키기 위한 필터이다.
        let invertFilter = CIFilter(name: "CIColorInvert")
        invertFilter?.setValue(transformed, forKey: kCIInputImageKey)

        // ✅ CIMaskToAlpha : grayscale 로 변환된 이미지를 alpha 로 마스킹된 흰색이미지로 변환.
        let alphaFilter = CIFilter(name: "CIMaskToAlpha")
        alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)
        
        // ✅ 받은 파라미터로 imageView 의 속성을 설정. 
        if let ouputImage = alphaFilter?.outputImage {
            imageView.tintColor = foregroundColor
            imageView.backgroundColor = backgroundColor

            // ✅ withRenderingMode(.alwaysTemplate) : 원본 이미지의 컬러정보가 사라지고 불투명한 부분을 tintColor 로 설정.
            imageView.image = UIImage(ciImage: ouputImage, scale: 2.0, orientation: .up).withRenderingMode(.alwaysTemplate)
        } else {
            return
        }
    }
}
```

- ✅ CIColorInvert : 색상을 반전시키기 위한 필터이다.

<img width="500" alt="2-1" src="https://user-images.githubusercontent.com/69136340/128882210-8158868e-4fd2-466e-aa8a-ed2fc02828b9.png">

- ✅ CIMaskToAlpha : grayscale 로 변환된 이미지를 alpha 로 마스킹된 흰색이미지로 변환.

<img width="500" alt="2" src="https://user-images.githubusercontent.com/69136340/128882227-d23b6398-5de7-4d08-99d7-49bdc8b76a60.png">

- QRCodeModalViewController.swift

QRCodeView 클래스를 통해서 qr code 를 만들어보자.

```swift
class QRCodeModalViewController: UIViewController {

    @IBOutlet weak var qrcodeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(origin: .zero, size: qrcodeView.frame.size)
        let qrcode = QRCodeView(frame: frame)

        // ✅ 내 깃허브 주소 문자열을 data 로 가지는 qr code.
        qrcode.generateCode("https://github.com/hyun99999", foregroundColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), backgroundColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        
        qrcodeView.addSubview(qrcode)
    }
}
```

### 결과

<img src ="https://user-images.githubusercontent.com/69136340/128903060-70a0b409-20e2-4fc9-a253-84bd405c331e.png" width ="250">

---

참고:

[Swift QRcode make](https://kodaewon.github.io/ios/2018/10/15/ios-qrcode/)

[iOS에서 QR 코드를 생성하는 방법](https://ichi.pro/ko/ioseseo-qr-kodeuleul-saengseonghaneun-bangbeob-266413765452800)

[Apple Developer - Core Image Filter Reference(CIFilter)](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci)

# QR코드 Reader 만들기

### 카메라 권한 얻기

- info.plist 에 추가한다.

<img src ="https://user-images.githubusercontent.com/69136340/128959662-ae0f3cef-2472-4c6c-aefd-c6511b7744bb.png" width ="600">

### [AVCaptureSession](https://developer.apple.com/documentation/avfoundation/avcapturesession/)

개발자 문서를 살펴보자

캡처 활동을 관리하고 입력 장치의 데이터 흐름을 조정하여 출력을 캡처하는 개체입니다.

**overview**

실시간 캡처를 수행하려면 AVCaptureSession 개체를 인스턴스화하고 적절한 inputs 및 outputs 를 추가합니다.

`startRunning()` 을 호출하여 input 에서 output 으로의 데이터 흐름을 시작하고 `stopRunning()`을 호출하여 흐름을 중지합니다.

`startRunning()` 메서드는 시간이 걸리는 blocking call 이므로 main queue 가 차단되지 않도록 serial queue 에서 세션 설정을 수행해야 합니다. (UI 를 반응적으로 유지하게 해준다.)

[`seesionPreset`](https://developer.apple.com/documentation/avfoundation/avcapturesession/1389696-sessionpreset) 속성을 사용해서 출력에 대한 품질 수준, 비트 전송률 또는 기타 설정을 사용자 지정합니다.(기본값은 high 입니다.

전반적인 순서

1️⃣  AVCaptureSession 개체를 인스턴스화

2️⃣  적절한 inputs 설정

3️⃣  적절한 ouputs 설정

- QRCodeReaderViewController : QR코드 reader 를 추가하고 읽은 정보를 다루는 뷰컨트롤러

```swift
import UIKit
import AVFoundation

class QRCodeReaderViewController: UIViewController {

    // 1️⃣ 실시간 캡처를 수행하기 위해서 AVCaptureSession 개체르 인스턴스화.
    private let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicSetting()
    }
    
}
extension QRCodeReaderViewController {
    
    private func basicSetting() {
        
        // ✅ AVCaptureDevice : capture sessions 에 대한 입력(audio or video)과 하드웨어별 캡처 기능에 대한 제어를 제공하는 장치.
        // ✅ 즉, 캡처할 방식을 정하는 코드.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
        
        // ✅ 시뮬레이터에서는 카메라를 사용할 수 없기 때문에 시뮬레이터에서 실행하면 에러가 발생한다.          
        fatalError("No video device found")
        }
        do {

            // 2️⃣ 적절한 inputs 설정
            // ✅ AVCaptureDeviceInput : capture device 에서 capture session 으로 media 를 제공하는 capture input. 
            // ✅ 즉, 특정 device 를 사용해서 input 를 초기화.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // ✅ session 에 주어진 input 를 추가.
            captureSession.addInput(input)
            
            // 3️⃣ 적절한 outputs 설정
            // ✅ AVCaptureMetadataOutput : capture session 에 의해서 생성된 시간제한 metadata 를 처리하기 위한 capture output.
            // ✅ 즉, 영상으로 촬영하면서 지속적으로 생성되는 metadata 를 처리하는 output 이라는 말.
            let output = AVCaptureMetadataOutput()

            // ✅ session 에 주어진 output 를 추가.
            captureSession.addOutput(output)

            // ✅             
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // ✅ 리더기가 인식할 수 있는 코드 타입을 정한다. 이 프로젝트의 경우 qr.
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

            // ✅ 카메라 영상이 나오는 layer 와 + 모양 가이드 라인을 뷰에 추가하는 함수 호출.           
            setVideoLayer()
            setGuideCrossLineView()
            
            // ✅ input 에서 output 으로의 데이터 흐름을 시작
            captureSession.startRunning()
        }
        catch {
            print("error")
        }
    }

    // ✅ 카메라 영상이 나오는 layer 를 뷰에 추가
    private func setVideoLayer() {
        // 영상을 담을 공간.
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // 카메라의 크기 지정
        videoLayer.frame = view.layer.bounds
        // 카메라의 비율지정
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
    }

    // ✅ + 모양 가이드라인을 뷰에 추가
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

// ✅ 
extension QRCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        // ✅ metadataObjects : 인식한 사물의 수
        if let metadataObject = metadataObjects.first {

            // ✅
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }

            // ✅ qr코드가 가진 문자열이 URL 형태를 띈다면 출력.(아무런 qr코드나 찍는다고 출력시키면 안되니까 여기서 분기처리 가능. )
            if stringValue.hasPrefix("http://") || stringValue.hasPrefix("https://")  {
                print(stringValue)

                // ✅ input 에서 output 으로의 흐름 중지
                self.captureSession.stopRunning()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
```

### 결과

<img src ="https://user-images.githubusercontent.com/69136340/128881724-a9c8aee5-74ff-488a-b6dc-dcccefb10ddb.gif" width ="250">

### 생각해볼 점

앞서 QR코드 클래스를 만들어서 사용했던 반면 QR코드 reader 는 정보를 읽고 다뤄야 하는 기능에 좀 더 집중해보기 위해서 편의상 뷰컨트롤러에서 다루어 주었다.

아래의 블로그를 참고하면 reader 를 클래스로 만들 수 있다. 클래스로 만들었을 때 우리가 고려해야하는 점은 뷰컨트롤러에 QR코드를 읽은 결과를 전달할 delegate 만들고 뷰컨트롤러에서 그 delegate 를 처리하는 부분을 구현해야 하는 것이다.

[QR, Barcode 리더기 만들기 - 뀔뀔(swieeft)의 개발새발기](https://swieeft.github.io/2020/02/25/QRCodeAndBarcodeReader.html)

참고 :

[[iOS] QR Code Scanner 만들기 - AvFoundation 이용](https://dongminyoon.tistory.com/19)

[IOS) QRCode 리더기 만들기](https://hururuek-chapchap.tistory.com/34)

