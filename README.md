# QRCodeReaderTutorial-iOS
🏁 make QRcode and QRcode Reader Tutorial
QR코드와 리더기를 만드는 오픈 라이브러리가 있지만 자체 라이브러리를 활용해서 만들어보기로 했다.

# 목차

- [QR코드 만들기](#qr코드-만들기)
- [QR코드 Reader 만들기](#qr코드-reader-만들기)
- [원하는 영역에서만 QR코드 읽기](#원하는-영역에서만-qr코드-읽기)

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

- 전반적인 순서와 metadata 에 대해서 먼저 알아보자

1️⃣  AVCaptureSession 개체를 인스턴스화

2️⃣  적절한 inputs 설정

3️⃣  적절한 ouputs 설정

4️⃣ `startRunning()` 과 `stopRunning()` 로 흐름 통제

[metadata](https://developer.apple.com/documentation/avfoundation/avcapturephotosettings/2875951-metadata) : 사진 파일 output 에 포함할 metadata keys 와 values 의 딕셔너리. 

즉, 여기서는 photo 데이터에 대한 데이터를 의미한다.

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

            // ✅ AVCaptureMetadataOutputObjectsDelegate 포로토콜을 채택하는 delegate 와 dispatch queue 를 설정한다.
            // ✅ queue : delegate 의 메서드를 실행할 큐이다. 이 큐는 metadata 가 받은 순서대로 전달되려면 반드시 serial queue(직렬큐) 여야 한다.     
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // ✅ 리더기가 인식할 수 있는 코드 타입을 정한다. 이 프로젝트의 경우 qr.
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

            // ✅ 카메라 영상이 나오는 layer 와 + 모양 가이드 라인을 뷰에 추가하는 함수 호출.           
            setVideoLayer()
            setGuideCrossLineView()
            
            // 4️⃣ startRunning() 과 stopRunning() 로 흐름 통제
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

// ✅ metadata capture ouput 에서 생성된 metatdata 를 수신하는 메서드.
// ✅ 이 프로토콜은 위에서처럼 AVCaptureMetadataOutput object 가 채택해야만 한다. 단일 메서드가 있고 옵션이다.
// ✅ 이 메서드를 사용하면 capture metadata ouput object 가 connection 을 통해서 관련된 metadata objects 를 수신할 때 응답할 수 있다.(아래 메서드의 파라미터를 통해 다룰 수 있다.)
// ✅ 즉, 이 프로토콜을 통해서 metadata 를 수신해서 반응할 수 있다.
extension QRCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {

    // ✅ caputure output object 가 새로운 metadata objects 를 보냈을 때 알린다.
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        // ✅ metadataObjects : 새로 내보낸 AVMetadataObject 인스턴스 배열이다.
        if let metadataObject = metadataObjects.first {

            // ✅ AVMetadataObject 는 추상 클래스이므로 이 배열의 object 는 항상 구체적인 하위 클래스의 인스턴스여야 한다.
            // ✅ AVMetadataObject 를 직접 서브클래싱해선 안된다. 대신 AVFroundation 프레임워크에서 제공하는 정의된 하위 클래스 중 하나를 사용해야 한다.
            // ✅ AVMetadataMachineReadableCodeObject : 바코드의 기능을 정의하는 AVMetadataObject 의 구체적인 하위 클래스. 인스턴스는 이미지에서 감지된 판독 가능한 바코드의 기능과 payload 를 설명하는 immutable object 를 나타낸다.
            // ✅ (참고로 이외에도 AVMetadataFaceObject 라는 감지된 단일 얼굴의 기능을 정의하는 subclass 도 있다.)
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }

            // ✅ qr코드가 가진 문자열이 URL 형태를 띈다면 출력.(아무런 qr코드나 찍는다고 출력시키면 안되니까 여기서 분기처리 가능. )
            if stringValue.hasPrefix("http://") || stringValue.hasPrefix("https://")  {
                print(stringValue)

                // 4️⃣ startRunning() 과 stopRunning() 로 흐름 통제
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

---
# 원하는 영역에서만 QR코드 읽기

우리가 접하는 QR코드 리더기는 특정 영역안에서 QR코드가 읽힌다. 그 이유로 나는 많은 QR코드가 카메라에 잡히지 않도록 사용자를 유도함과 동시에 사용자가 본인의 QR코드를 입력하는 인식을 주기 위함이라고 생각이 든다. 핸드폰을 제대로 가져다 대지도 않았는데 조금이라도 카메라에 노출된 QR코드가 바로 읽힌다면 사용자는 분명 당황스러울 것이다.

그래서 이런 이유로 QR코드 영역을 지정하는 것을 해보려 한다.

- `AVCaputureMetadataOutput` 의 `rectOfInterest` 속성을 이용하면 된다. 먼저 개발자 문서를 살펴보자.

### [rectOfInterest](https://developer.apple.com/documentation/avfoundation/avcapturemetadataoutput/1616291-rectofinterest/)

- 시각적 metatdata 의 검색 영역을 제한하기 위한 사각형을 결정하는 `CGRect` 값이다.
- 사각형의 origin(원점) 은 왼쪽 상단이고 metatdat 를 제공하는 장치의 좌표공간을 기준으로 한다.
- rectangle of interest 를 지정하면 특정 유형의 metadata 에 대한 감지 능력이 향상될 수 있다. `rectOfInterest` 를 가로지르는 metadata ojects 의 bounds 가 아니면 리턴하지 않는다.(즉 사각형안에 있지 않으면 인식하지 않는다는 말.)
- 기본값은 (0.0, 0.0, 1.0, 1.0) 이다.

**기본값이....? 조금 이상하다. width 와 height 에 기본값이 1.0 이라.. 실제로 값을 나중에 출력해보면 알겠지만 0~100% 까지  비율의 프레임을 채운다고 한다. 그래서 아무런 속성설정 없는 기본값에서는 전체 프레임에서 qr코드를 인식했었다.**

그래서 우리는  `metadataOutputRectConverted` 를 사용해서 비율로 변환해주어야 한다.

### [metadataOutputRectConverted](https://developer.apple.com/documentation/avfoundation/avcapturevideopreviewlayer/1623495-metadataoutputrectconverted)

- preview layer(여기서는 AVCaptureVideoPreviewLayer 개체에 해당) 의 metadata ouputs 에 사용되는 좌표계의 사각형으로 변환.

`+`  모양이었던 가이드 라인에서 **정사각형의 가이드라인을 보여주고 거기서만 QR코드가 읽히도록 해보자.** 

가이드라인을 그리는 작업은 최근에 읽었던 zedd 님의 UIBezierPath 에 관한 글을 읽어봤고 활용해보기로 했다.

[iOS ) UIBezierPath (3) - Triangle, Circle](https://zeddios.tistory.com/822?category=682195)

### 완성

<img src ="https://user-images.githubusercontent.com/69136340/129237145-666742e1-5769-4578-9ff5-05adebfde216.gif" width ="250">

### 코드

- QRCodeReaderViewController.swift

✅ **영역 제한**

```swift
extension QRCodeReaderViewController {
    
    private func basicSetting() {
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        do {
            // ✅ 제한하고 싶은 영역
            let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2 , y: (UIScreen.main.bounds.height - 200) / 2, width: 200, height: 200)
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // ✅ preview layer 에서의 영역 변환값을 리턴받아 사용하기 위해서 기존 코드에서 수정해주었다.
            let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)

            // ✅ rectOfInterest 를 설정(=제한영역 설정 완료)
            output.rectOfInterest = rectConverted

            // ✅ 정사각형 가이드 라인 추가
            setGuideCrossLineView(rectOfInterest: rectOfInterest)
            
            captureSession.startRunning()
        }
        catch {
            print("error")
        }
    }
    
    // ✅ preview layer 에서의 영역 변환값을 리턴받아 사용하기 위해서 기존 코드에서 수정해주었다.
    private func setVideoLayer(rectOfInterest: CGRect) -> CGRect{
        // 영상을 담을 공간.
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //카메라의 크기 지정
        videoLayer.frame = view.layer.bounds
        //카메라의 비율지정
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        
        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }

    private func setGuideCrossLineView(rectOfInterest: CGRect) { 
    //...
    }
}
```

✅ **가이드라인 추가**

```swift
extension QRCodeReaderViewController {

    // ...

    private func setGuideCrossLineView(rectOfInterest: CGRect) {

        // 생략된 코드는 + 모양 가이드라인 추가 코드이다.
        // ...
        
        let cornerLength: CGFloat = 20
        let cornerLineWidth: CGFloat = 5
        
        // ✅ 가이드라인의 각 모서리 point
        let upperLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.minY)
        let upperRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.minY)
        let lowerRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.maxY)
        let lowerLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.maxY)
        
        // ✅ 각 모서리를 중심으로 한 Edge를 그림.
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
        
        // ✅ layer 에 추가
        
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

**참고 : **
[[iOS] Swift QRCode 읽기](https://nebori.tistory.com/28)

