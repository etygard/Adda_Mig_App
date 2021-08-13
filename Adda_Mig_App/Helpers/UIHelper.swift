//
//  UIHelper.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-20.
//

import UIKit

class UIHelper {
    var window: UIWindow?
    
    
    class func setRoundImage(selectedImageView: UIImageView!){
        if let imageView = selectedImageView {
            let cornerRadius = imageView.image?.size.height ?? 0
            
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = CGFloat(cornerRadius/2)
            imageView.layer.maskedCorners = [
                .layerMaxXMaxYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMinYCorner
            ]
        }
    }
    class func setRadius(selectedView: UIView!, cornerRadius: Int ){
        selectedView.layer.cornerRadius = CGFloat(cornerRadius)
    }

    class func setupBackgrounds(cicleView: UIView!) {
        let cornerRadius = cicleView.frame.height
        cicleView.clipsToBounds = true
        cicleView.layer.cornerRadius = CGFloat(cornerRadius/2)
        cicleView.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner
        ]
    }
    
    class func setMaskedRoundOnBottomCorners(selectedView: UIView!, cornerRadius: Int ){
        selectedView.clipsToBounds = true
        selectedView.layer.cornerRadius = CGFloat(cornerRadius)
        selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    class func setMaskedRoundOnTopCorners(selectedView: UIView!, cornerRadius: Int ){
        selectedView.clipsToBounds = true
        selectedView.layer.cornerRadius = CGFloat(cornerRadius)
        selectedView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
     
    
}


