//
//  MovieNavigationController.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class MovieNavigationController: UINavigationController {
    
    weak var customBarView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationBarInvisible()
    }
    
    func removeCurrentCustomBarView(){
        //make sure customBarView is cleared out
        customBarView?.removeFromSuperview()
        customBarView = nil
    }
    func setCustomBarView(_ customView:UIView) {
        
        removeCurrentCustomBarView()
        
        customBarView = customView
        
        if let customBarView = customBarView {
        self.view.addSubview(customBarView)
    
        customBarView.leftAnchor.constraint(equalTo: navigationBar.leftAnchor).isActive=true
        customBarView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor).isActive=true
        customBarView.topAnchor.constraint(equalTo: navigationBar.topAnchor).isActive=true
        customBarView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive=true
        }
    }
    
    @objc func testTap(_ tap:UITapGestureRecognizer){
        print("tapping navigation custombarview")
    }
    func makeNavigationBarInvisible() {
        navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        setNavigationBarHidden(false, animated:true)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        removeCurrentCustomBarView()
        return super.popViewController(animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        removeCurrentCustomBarView() //will need to set the bar on viewWillAppear from viewController because of this, because on popping the view will be gone
        super.pushViewController(viewController, animated: animated)
    }
}
