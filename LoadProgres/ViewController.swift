//
//  ViewController.swift
//  LoadProgres
//
//  Created by Всеволод Андрющенко on 24/07/2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    let shapeLayer = CAShapeLayer()
    let backgroundGradient = CAGradientLayer()
    
    let urlString = "https://www.dropbox.com/s/9z3g7opfiahdv2s/1Cv8.1CD?dl=1"
    
    
    
    let prosentLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.font = UIFont.italicSystemFont(ofSize: 45)
        label.textAlignment = .center
        label.textColor = UIColor.yellow
        return label
    }()
    
    let endDonloadLabel: UILabel = {
        let label = UILabel()
        label.text = "Load"
        label.textColor = UIColor.yellow
        label.font = UIFont.italicSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupBackgroundLayer()
        setupProgressBar()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGest)))
    }
    
    private func setupBackgroundLayer(){
        let background = CAGradientLayer()
        background.frame = self.view.bounds
        background.colors = [UIColor.gray.cgColor, UIColor.orange.cgColor]
        background.startPoint = CGPoint(x: 0.57, y: 0.75)
        background.endPoint = CGPoint(x: 0.55, y: 1)
        self.view.layer.addSublayer(background)
    }
    
    // Setup view
    private func setupProgressBar(){
        
        let center = view.center
        
        let pathLayer = CAShapeLayer()
        let crushalPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        pathLayer.path = crushalPath.cgPath
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineWidth = 10
        pathLayer.strokeColor = UIColor.darkGray.cgColor
        self.view.layer.addSublayer(pathLayer)
        
        let backgroundProgress = UIView()
        backgroundProgress.frame = CGRect(x: 0, y: 0, width: 89.0*2, height: 89.0*2)
        backgroundProgress.center = center
        backgroundProgress.backgroundColor = .clear
        backgroundProgress.layer.cornerRadius = 89.0
        
        backgroundGradient.frame = backgroundProgress.bounds
        backgroundGradient.cornerRadius = 89.0
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 1)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundGradient.colors = [UIColor.clear.cgColor, UIColor.green.cgColor]
        
        backgroundProgress.layer.addSublayer(backgroundGradient)
        self.view.addSubview(backgroundProgress)
        
        
        let progresPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        shapeLayer.position = center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        shapeLayer.path = progresPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        shapeLayer.shadowRadius = 6
        shapeLayer.shadowColor = UIColor.green.cgColor
        shapeLayer.shadowOpacity = 0.6
        
        self.view.layer.addSublayer(shapeLayer)
        
        prosentLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 100)
        prosentLabel.center = center
        self.view.addSubview(prosentLabel)
        
        endDonloadLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        endDonloadLabel.center.x = center.x
        endDonloadLabel.center.y = center.y + 30
        //endDonloadLabel.topAnchor.constraint(equalTo: prosentLabel.bottomAnchor, constant: 8).isActive = true
        //self.view.addSubview(endDonloadLabel)
        
    }

    
    private func beginDonload(){
        
        let configuration = URLSessionConfiguration.default
        let opertionQueue = OperationQueue()
        guard let url = URL(string: urlString) else {return}
        let urlSession = URLSession(configuration: configuration, delegate: self , delegateQueue: opertionQueue)
        let donloadTask = urlSession.downloadTask(with: url)
        donloadTask.resume()
    }
    
    private func loadOverAnimation(){
        
    }
    
    //fileprivate func donloadAnimation() {
    //    let loadAnimation = CABasicAnimation(keyPath: "strokeEnd")
    //    loadAnimation.toValue = 1
    //    loadAnimation.isRemovedOnCompletion = false
    //    loadAnimation.duration = 10
    //    loadAnimation.fillMode = .forwards
    //
    //    shapeLayer.add(loadAnimation, forKey: "key")
    //
    //
    //    let loadBackgroundAnimation = CABasicAnimation(keyPath: "startPoint")
    //    loadBackgroundAnimation.toValue = CGPoint(x: 0.5, y: 0)
    //    loadBackgroundAnimation.duration = 10
    //    loadBackgroundAnimation.fillMode = .forwards
    //    loadBackgroundAnimation.isRemovedOnCompletion = false
    //
    //    backgroundGradient.add(loadBackgroundAnimation, forKey: "key")
    //}
    private var isLoad: Bool = false
    
    @objc private func handleTapGest(){
        
        if isLoad == false {
            isLoad = true
            beginDonload()
            endDonloadLabel.removeFromSuperview()
        }
    }
    
}
extension ViewController{
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            self.view.addSubview(self.endDonloadLabel)
            self.shapeLayer.lineWidth = 13
        }
        isLoad = false
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let procentLoad = CGFloat(totalBytesWritten)/CGFloat(totalBytesExpectedToWrite)

        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = procentLoad
            self.prosentLabel.text = "\(Int(procentLoad * 100))%"
            self.backgroundGradient.startPoint = CGPoint(x: 0.5, y: 1 - procentLoad)
         }
    }
}

