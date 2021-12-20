//
//  ThumbnailPopUpViewController.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class ThumbnailPopUpViewController: UIViewController, UIGestureRecognizerDelegate {
    lazy var thumbnailImageView:UIImageView = {
        let thumbnailImage = ViewGenerator.getUIImageView(image: nil, contentMode: .scaleAspectFit, background: .clear, border: .rounded)
        return thumbnailImage
    }()
    let thumbnailImageContainer:UIView = ViewGenerator.getUIView(background: .clear)
    
    lazy var thumbnailBackgroundOverlay:UIVisualEffectView = {
        var blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        if AppStyleGenerator.getMode() == .dark {
            blur =  UIBlurEffect(style: UIBlurEffect.Style.dark)
        }
        var blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    lazy var thumbnailBackgroundImage:UIImageView = {
        let thumbnailBackgroundImage:UIImageView = ViewGenerator.getUIImageView(image: UIImage(named: AssetConstants.IMAGE_NOT_AVAILABLE), contentMode: .scaleAspectFill, background: .dark, isOpaque: false, alpha: 1.0)
        return thumbnailBackgroundImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
    }
    
    weak var thumbnail:UIImage? {
        didSet {
            thumbnailImageView.image = thumbnail
            thumbnailBackgroundImage.image = thumbnail
        }
    }
    
    //MARK: Initialization
    init(thumbnail: UIImage){
        super.init(nibName: nil, bundle: nil)
        
        setupAutoLayout()
        //This is almost certainly not necessary to not have a memory leak..
        guard let cgImage = thumbnail.cgImage?.copy() else {
                return
            }
        let newImage = UIImage(cgImage: cgImage,
                               scale: thumbnail.scale,
                               orientation: thumbnail.imageOrientation)
        
        thumbnailImageView.image = newImage.withRoundedCorners(radius: GridCellSizeCalculator.thumbnailCornerRadius)
        thumbnailBackgroundImage.image = newImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard not supported")
    }
    
    func setupAutoLayout(){
        self.view.addSubview(thumbnailBackgroundImage)
        thumbnailBackgroundImage.constrainSidesTo(view: self.view)
        thumbnailBackgroundImage.addSubview(thumbnailBackgroundOverlay)
        thumbnailBackgroundOverlay.constrainSidesTo(view: thumbnailBackgroundImage)
        
        self.view.addSubview(thumbnailImageView)
        thumbnailImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        thumbnailImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive=true
        thumbnailImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.85).isActive=true
        thumbnailImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive=true
        
        //remove this line if you want to show up over mainViewController, and not black it out
        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePopUp(_:))))
        
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    @objc func removeAnimate()
    {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{ [weak self] (finished : Bool)  in
            if (finished)
            {
                guard let self = self else { return }
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        });
    }
    
    var didLayoutSubviews:Bool = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLayoutSubviews {
            //frame based layouts
            didLayoutSubviews = true
            thumbnailImageView.addShadowToImageNotLayer(blurSize: 5.0)
        }
    }
}

