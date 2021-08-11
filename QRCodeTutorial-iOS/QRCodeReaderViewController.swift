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
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            setVideoLayer()
            setGuideCrossLineView()
            
            captureSession.startRunning()
        }
        catch {
            print("error")
        }
    }
    private func setVideoLayer() {
        // 영상을 담을 공간.
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //카메라의 크기 지정
        videoLayer.frame = view.layer.bounds
        //카메라의 비율지정
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
    }
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

