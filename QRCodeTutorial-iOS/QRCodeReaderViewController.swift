//
//  QRCodeReaderViewController.swift
//  QRCodeTutorial-iOS
//
//  Created by kimhyungyu on 2021/08/09.
//

import UIKit
import AVFoundation

class QRCodeReaderViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicSetting()
    }
    
}
extension QRCodeReaderViewController {
    
    private func basicSetting() {
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        do {
            // 제한하고 싶은 영역
            let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2 , y: (UIScreen.main.bounds.height - 200) / 2, width: 200, height: 200)
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)
            setGuideCrossLineView(rectOfInterest: rectOfInterest)
            output.rectOfInterest = rectConverted
            
            captureSession.startRunning()
        }
        catch {
            print("error")
        }
    }
    
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
        
        let cornerLength: CGFloat = 20
        let cornerLineWidth: CGFloat = 5
        
        // Focus Zone의 각 모서리 point
        let upperLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.minY)
        let upperRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.minY)
        let lowerRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.maxY)
        let lowerLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.maxY)
        
        // 각 모서리를 중심으로 한 Edge를 그림.
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
        
        // layer 에 추가
        
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

extension QRCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }
            if stringValue.hasPrefix("http://") || stringValue.hasPrefix("https://")  {
                print(stringValue)
                
                self.captureSession.stopRunning()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

