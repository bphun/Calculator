//
//  ImageBasedInputViewController.swift
//  Calculator
//
//  Created by Brandon Phan on 8/30/17.
//  Copyright © 2017 Brandon Phan. All rights reserved.
//

import UIKit
import AVFoundation

class ImageBasedInputViewController: UIViewController {

	var captureSession: AVCaptureSession?
	var videoPreviewLayer: AVCaptureVideoPreviewLayer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let captureDevice = AVCaptureDevice.default(for: .video)
		
		var input: AVCaptureDeviceInput!
		do {
			input = try AVCaptureDeviceInput(device: captureDevice!)
		} catch {
			print(error)
		}
		
		captureSession = AVCaptureSession()
		captureSession?.addInput(input)
		
		videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
		videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
		videoPreviewLayer?.frame = view.layer.bounds
		view.layer.addSublayer(videoPreviewLayer!)
		captureSession?.startRunning()
	}

	
}
