//
//  LottieButton.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/07.
//

import UIKit
import Lottie

class LottieButton: UIButton {
    
    private var lottieAssetName: String = ""
    private var loopMode: LottieLoopMode = .playOnce
    private var animationSpeed: CGFloat = 0.5
    private var transformAngle: CGFloat = .pi
    
    private var lottieView: LottieAnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ lottieText: String, loopMode: LottieLoopMode, animationSpeed: CGFloat, transformAngle: CGFloat) {
        self.init(frame: .zero)
        
        self.lottieAssetName = lottieText
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.transformAngle = transformAngle
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        lottieView?.play()
    }
    
    func pause() {
        lottieView?.pause()
    }
}

extension LottieButton {
    private func configureUI() {
        let lottieView = LottieAnimationView(asset: lottieAssetName)
        
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.loopMode = loopMode
        lottieView.animationSpeed = animationSpeed
        lottieView.transform = CGAffineTransform(rotationAngle: transformAngle)
        
        self.addSubview(lottieView)
        
        NSLayoutConstraint.activate([
            lottieView.topAnchor.constraint(equalTo: self.topAnchor),
            lottieView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lottieView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lottieView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.lottieView = lottieView
    }
}
