//
//  KeyboardViewModel.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import Foundation
import UIKit

class KeyboardViewModel {
    
    var keyboardResponder:UIResponder? //needs to be set whenever you click into a text box that will show a keyboard
    
    var keyboardDismissileView:UIView = {
        let keyboardDismissileView = UIView()
        keyboardDismissileView.translatesAutoresizingMaskIntoConstraints = false
        keyboardDismissileView.backgroundColor = UIColor.clear
        return keyboardDismissileView
    }()
    
    var keyboardDismissileViewConstraints:[NSLayoutConstraint] = [NSLayoutConstraint]()
    var keyboardDismissileViewTopAnchorConstraint:NSLayoutConstraint?
    var keyboardDismissileViewBottomAnchorConstraint:NSLayoutConstraint? //totally optional
    
    var isKeyboardShowing:Bool = false
    
    var willShow: ((CGRect) -> ())? //rect is keyboard frame
    var willHide: (() -> ())?
    weak var viewController: UIViewController? {
        didSet {
            print("keyboardViewModel VC set")
        }
    }
    
    init(willShow: ((CGRect) -> ())?, willHide: (() -> ())?, viewController: UIViewController?, keyboardDismissileViewTopAnchorConstraint:NSLayoutConstraint? = nil, keyboardDismissileViewBottomAnchorConstraint:NSLayoutConstraint? = nil){
        self.willShow = willShow
        self.willHide = willHide
        self.viewController = viewController
        self.keyboardDismissileViewTopAnchorConstraint = keyboardDismissileViewTopAnchorConstraint
        self.keyboardDismissileViewBottomAnchorConstraint = keyboardDismissileViewBottomAnchorConstraint
        setObserver()
    }
    
    func setObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsetObserver(){ // Call this from wherever necessary in your VC
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {
        print("keyboardWillAppear keyboardViewModel")
                
        var keyboardHeight:CGFloat = 0
        var bottomSafeArea:CGFloat = 0
        
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        guard let viewController = viewController else {
            return
        }
        
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - viewController.view.safeAreaInsets.bottom
            bottomSafeArea = viewController.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
            bottomSafeArea = viewController.bottomLayoutGuide.length
        }
        
        bottomSafeArea = bottomSafeArea + keyboardHeight
        
        keyboardDismissileView.removeFromSuperview() //just in case already in superview
        viewController.view.addSubview(keyboardDismissileView)
        
        //keyboardDismissileViewTopAnchor will be used to not cover the search bar
        let topAnchor = keyboardDismissileViewTopAnchorConstraint ?? keyboardDismissileView.topAnchor.constraint(equalTo: viewController.view.topAnchor)
        let bottomAnchor = keyboardDismissileViewBottomAnchorConstraint ?? keyboardDismissileView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: -bottomSafeArea)
        keyboardDismissileViewConstraints = [
        keyboardDismissileView.leftAnchor.constraint(equalTo: viewController.view.leftAnchor),
        keyboardDismissileView.rightAnchor.constraint(equalTo: viewController.view.rightAnchor),
        topAnchor,
        bottomAnchor]
        
        NSLayoutConstraint.activate(keyboardDismissileViewConstraints)
        
        let hideKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        keyboardDismissileView.addGestureRecognizer(hideKeyboardGestureRecognizer)
        
        isKeyboardShowing = true
        
        if let notification = notification, let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                //keyboardVisibleHeight = frame.size.height
                self.willShow?(frame)
            }
        }
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) { //when triggered from clicking search button (from searchBar, for some reason doesn't remove it but only the FIRST time)
        print("keyboardWillDisappear keyboardViewModel")
        keyboardDismissileView.removeFromSuperview()
        self.keyboardResponder = nil
        isKeyboardShowing = false
        self.willHide?() //if you need to do anything after the keyboard disappears
    }
    
    @objc
    func hideKeyboard(_ gesture: UITapGestureRecognizer){
        keyboardResponder?.resignFirstResponder() //hide the keyboard, should trigger the keyboardWillDisappear function
        gesture.view?.removeFromSuperview()
        keyboardDismissileView.removeFromSuperview()

    }
}
