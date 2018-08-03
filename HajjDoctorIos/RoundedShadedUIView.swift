//
//  RoundedShadedUIView.swift
//  HajjDoctorIos
//
//  Created by Hosam Elsafty on 8/2/18.
//  Copyright © 2018 Hosam Elsafty. All rights reserved.
//

import UIKit

class RoundedShadedUIView: UIView {

    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        if shadowLayer == nil {
            print("asdfsdfsaddafdfsadfasdsfsdfsa")
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
