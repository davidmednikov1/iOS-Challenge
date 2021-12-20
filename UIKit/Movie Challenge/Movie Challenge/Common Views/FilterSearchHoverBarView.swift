//
//  FilterSearchHoverBarView.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

//basically should make it so that SearchHoverBarView can't be touched itself (so won't block views behind it), but all its subviews will still be touchable
class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

protocol EnterSearchDelegate:class {
    func enterSearch()
}
//MARK: Restylable Extension
extension FilterSearchHoverBarView:Restylable {
    func restyle() {
        roundShadowBackgroundView.style(AppStyleGenerator.getViewStyle(for: .NewInfoBackground))
        searchTextField.style(AppStyleGenerator.getLabelStyle(for: .ClearBackgroundLabelAgainstModeColor))
        searchIconImageView.style(AppStyleGenerator.getImageViewStyle(for: .NewClearBackgroundSubtitleTintedImageView))
        clearSearchLabel.style(AppStyleGenerator.getImageViewStyle(for: .ClearBackgroundImageViewThemedAgainstModeColor))
        filterIconImageView.style(AppStyleGenerator.getImageViewStyle(for: .ClearBackgroundOppositeModeTintedImageView))
    }
}
extension FilterSearchHoverBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardViewModel.keyboardResponder = self.searchTextField
        self.searchBarTextDelegate?.textFieldDidBeginEditing?(textField)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.searchBarTextDelegate?.textFieldDidEndEditing?(textField)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //when return or "search" button is tapped
        textField.resignFirstResponder()
        return self.searchBarTextDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if newString.isEmpty {
            self.clearSearchLabel.isHidden=true
            self.clearSearchLabelBackground.isHidden=true
            searchIconImageView.isHidden=false
        }
        else {
            self.clearSearchLabel.isHidden=false
            self.clearSearchLabelBackground.isHidden=false
            searchIconImageView.isHidden=true
        }
        return true
    }
}

class FilterSearchHoverBarView: PassthroughView, EnterSearchDelegate {
    //MARK: Properties
    var keyboardViewModel:KeyboardViewModel
    weak var searchBarTextDelegate:UITextFieldDelegate?
    
    let roundShadowBackgroundView:UIView = {
        let roundShadowBackgroundView = ViewGenerator.getUIView(appUIElement: .NewInfoBackground)
        roundShadowBackgroundView.layer.masksToBounds = true
        roundShadowBackgroundView.layer.cornerRadius = FilterSearchHoverBarView.cornerRadiusForShadow
        return roundShadowBackgroundView
    }()
    
    lazy var searchTextField:UITextField = {
        let searchTextField = UITextField()
        searchTextField.textAlignment = .center
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.style(AppStyleGenerator.getLabelStyle(for: .ClearBackgroundLabelAgainstModeColor))
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        
        searchTextField.placeholder = "Type..."
        searchTextField.textAlignment = .left
        return searchTextField
    }()
    
    let searchIconImageView:UIImageView = ViewGenerator.getUIImageView(appUIElement: .NewClearBackgroundSubtitleTintedImageView, image: UIImage(named: AssetConstants.search)?.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit, border: .normal, touchable: true)
    
    let filterIconImageView:UIImageView = ViewGenerator.getUIImageView(appUIElement: .ClearBackgroundOppositeModeTintedImageView, image: UIImage(named: AssetConstants.Tabs.search_filters)?.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit, border: .normal, touchable: true)
    
    
    let clearSearchLabel:UIImageView = {
        let clearSearchLabel:UIImageView = ViewGenerator.getUIImageView(appUIElement: .ClearBackgroundImageViewThemedAgainstModeColor, image: UIImage(named: AssetConstants.CLEAR_SEARCH)?.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        clearSearchLabel.isUserInteractionEnabled = true
        return clearSearchLabel
    }()
    let clearSearchLabelBackground:UIView = ViewGenerator.getUIView(appUIElement: .NewInfoBackground)
    
    //MARK: Initialization
    init(keyboardViewModel: KeyboardViewModel, searchBarTextDelegate:UITextFieldDelegate,/* tagDelegate:FilterTagDelegate?,*/ placeholder: String){
        self.keyboardViewModel = keyboardViewModel
        self.searchBarTextDelegate = searchBarTextDelegate
        
        super.init(frame: .zero)
        
        setupAutoLayout()
        self.searchTextField.placeholder = placeholder
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    static let shadowInset:CGFloat = 3.0
    static let cornerRadiusForShadow:CGFloat = 18.0
    static let inset:CGFloat = 18.0
    static let height:CGFloat = FilterSearchHoverBarView.minimumTouchableHeight + (FilterSearchHoverBarView.inset * 2.0)
    static let minimumTouchableHeight:CGFloat = 54
    static let cornerRadiusForMinimumTouchableHeight:CGFloat = 18.0
    func setupAutoLayout(){
        self.backgroundColor = UIColor.clear
        
        self.addSubview(roundShadowBackgroundView)
        self.addSubview(searchTextField)
        self.addSubview(searchIconImageView)
        self.addSubview(filterIconImageView)
        
        self.addSubview(clearSearchLabelBackground)
        self.addSubview(self.clearSearchLabel)
        clearSearchLabelBackground.layer.cornerRadius = FilterSearchHoverBarView.minimumTouchableHeight / 2.0
        clearSearchLabel.topAnchor.constraint(equalTo: searchTextField.topAnchor).isActive=true
        clearSearchLabel.leftAnchor.constraint(equalTo: roundShadowBackgroundView.leftAnchor, constant: FilterSearchHoverBarView.inset).isActive=true
        clearSearchLabel.heightAnchor.constraint(equalTo: searchTextField.heightAnchor).isActive=true
        clearSearchLabel.widthAnchor.constraint(equalTo: searchTextField.heightAnchor).isActive=true
        
        clearSearchLabelBackground.topAnchor.constraint(equalTo: searchTextField.topAnchor).isActive=true
        clearSearchLabelBackground.leftAnchor.constraint(equalTo: roundShadowBackgroundView.leftAnchor, constant: FilterSearchHoverBarView.inset).isActive=true
        clearSearchLabelBackground.heightAnchor.constraint(equalTo: searchTextField.heightAnchor).isActive=true
        clearSearchLabelBackground.widthAnchor.constraint(equalTo: searchTextField.heightAnchor).isActive=true
        clearSearchLabel.isHidden=true
        clearSearchLabelBackground.isHidden=true
        searchIconImageView.isHidden=false
        searchIconImageView.constrainSidesTo(view: clearSearchLabel)
        
        keyboardShowingConstraints = [
            roundShadowBackgroundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: FilterSearchHoverBarView.inset),
            roundShadowBackgroundView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -FilterSearchHoverBarView.inset),
            roundShadowBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: FilterSearchHoverBarView.inset),
            roundShadowBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -FilterSearchHoverBarView.inset),
            searchTextField.leftAnchor.constraint(equalTo: clearSearchLabel.rightAnchor, constant: FilterSearchHoverBarView.inset),
            searchTextField.rightAnchor.constraint(equalTo: filterIconImageView.leftAnchor, constant: -FilterSearchHoverBarView.inset),
            searchTextField.topAnchor.constraint(equalTo: roundShadowBackgroundView.topAnchor, constant: FilterSearchHoverBarView.inset),
            searchTextField.bottomAnchor.constraint(equalTo: roundShadowBackgroundView.bottomAnchor, constant: -FilterSearchHoverBarView.inset),
            filterIconImageView.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            filterIconImageView.rightAnchor.constraint(equalTo: roundShadowBackgroundView.rightAnchor, constant: -FilterSearchHoverBarView.inset),
            filterIconImageView.heightAnchor.constraint(equalTo: searchTextField.heightAnchor),
            filterIconImageView.widthAnchor.constraint(equalTo: searchTextField.heightAnchor)
        ]
        
        keyboardHiddenHasTextConstraints = [
            roundShadowBackgroundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: FilterSearchHoverBarView.inset),
            roundShadowBackgroundView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -FilterSearchHoverBarView.inset),
            roundShadowBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: FilterSearchHoverBarView.inset),
            roundShadowBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -FilterSearchHoverBarView.inset),
            searchTextField.leftAnchor.constraint(equalTo: clearSearchLabel.rightAnchor, constant: FilterSearchHoverBarView.inset),
            searchTextField.rightAnchor.constraint(equalTo: filterIconImageView.leftAnchor, constant: -FilterSearchHoverBarView.inset),
            searchTextField.topAnchor.constraint(equalTo: roundShadowBackgroundView.topAnchor, constant: FilterSearchHoverBarView.inset),
            searchTextField.bottomAnchor.constraint(equalTo: roundShadowBackgroundView.bottomAnchor, constant: -FilterSearchHoverBarView.inset),
            filterIconImageView.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            filterIconImageView.rightAnchor.constraint(equalTo: roundShadowBackgroundView.rightAnchor, constant: -FilterSearchHoverBarView.inset),
            filterIconImageView.heightAnchor.constraint(equalTo: searchTextField.heightAnchor),
            filterIconImageView.widthAnchor.constraint(equalTo: searchTextField.heightAnchor)
        ]
        
        
        keyboardHiddenNoTextConstraints = [
            roundShadowBackgroundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: FilterSearchHoverBarView.inset),
            roundShadowBackgroundView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -FilterSearchHoverBarView.inset),
            roundShadowBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: FilterSearchHoverBarView.inset),
            roundShadowBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -FilterSearchHoverBarView.inset),
            searchTextField.leftAnchor.constraint(equalTo: clearSearchLabel.rightAnchor, constant: FilterSearchHoverBarView.inset),
            searchTextField.rightAnchor.constraint(equalTo: filterIconImageView.leftAnchor, constant: -FilterSearchHoverBarView.inset),
            searchTextField.topAnchor.constraint(equalTo: roundShadowBackgroundView.topAnchor, constant: FilterSearchHoverBarView.inset),
            searchTextField.bottomAnchor.constraint(equalTo: roundShadowBackgroundView.bottomAnchor, constant: -FilterSearchHoverBarView.inset),
            filterIconImageView.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            filterIconImageView.rightAnchor.constraint(equalTo: roundShadowBackgroundView.rightAnchor, constant: -FilterSearchHoverBarView.inset),
            filterIconImageView.heightAnchor.constraint(equalTo: searchTextField.heightAnchor),
            filterIconImageView.widthAnchor.constraint(equalTo: searchTextField.heightAnchor)
        ]
        
        switchToKeyboardHiddenMode()
        
        searchIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enterSearch)))
        clearSearchLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearSearchTerm)))
        filterIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editFilters)))
    }
    
    @objc func editFilters(){
        
    }
    @objc func clearSearchTerm(){
        searchTextField.text = ""
        clearSearchLabel.isHidden=true
        clearSearchLabelBackground.isHidden=true
        searchIconImageView.isHidden=false
        if !keyboardViewModel.isKeyboardShowing {
            switchToKeyboardHiddenMode() //shrink us back down
        }
    }
    
    @objc func enterSearch(){
        searchTextField.becomeFirstResponder()
    }
    
    var keyboardShowingConstraints:[NSLayoutConstraint] = [NSLayoutConstraint]()
    var keyboardHiddenNoTextConstraints:[NSLayoutConstraint] = [NSLayoutConstraint]()
    var keyboardHiddenHasTextConstraints:[NSLayoutConstraint] = [NSLayoutConstraint]()
    func switchToKeyboardShowingMode(){
        let searchEmpty = searchTextField.text?.isEmpty ?? true
        UIView.animate(withDuration: 0.5) { [unowned self] in
            NSLayoutConstraint.deactivate(self.keyboardHiddenHasTextConstraints)
            NSLayoutConstraint.deactivate(self.keyboardHiddenNoTextConstraints)
            NSLayoutConstraint.deactivate(self.keyboardShowingConstraints) //this is just so everything is deactivated before adding new constraints
            NSLayoutConstraint.activate(self.keyboardShowingConstraints)
            if searchEmpty {
                self.clearSearchLabel.isHidden=true
                self.clearSearchLabelBackground.isHidden=true
                searchIconImageView.isHidden=false
            }
            else {
                self.clearSearchLabel.isHidden=false
                self.clearSearchLabelBackground.isHidden=false
                searchIconImageView.isHidden=true
            }
            
        }
        self.layoutIfNeeded()
    }
    func switchToKeyboardHiddenMode(){
        if searchTextField.text?.isEmpty ?? true {
            UIView.animate(withDuration: 0.5) { [unowned self] in
                NSLayoutConstraint.deactivate(self.keyboardShowingConstraints)
                NSLayoutConstraint.deactivate(self.keyboardHiddenHasTextConstraints)
                NSLayoutConstraint.deactivate(self.keyboardHiddenNoTextConstraints) //this is just so everything is deactivated before adding new constraints
                NSLayoutConstraint.activate(self.keyboardHiddenNoTextConstraints)
                self.clearSearchLabel.isHidden=true
                self.clearSearchLabelBackground.isHidden=true
                searchIconImageView.isHidden=false
            }
            self.layoutIfNeeded()
        }
        else {
            UIView.animate(withDuration: 0.5) { [unowned self] in
                NSLayoutConstraint.deactivate(self.keyboardShowingConstraints)
                NSLayoutConstraint.deactivate(self.keyboardHiddenNoTextConstraints)
                NSLayoutConstraint.deactivate(self.keyboardHiddenHasTextConstraints) //this is just so everything is deactivated before adding new constraints
                NSLayoutConstraint.activate(self.keyboardHiddenHasTextConstraints)
                self.clearSearchLabel.isHidden=false
                self.clearSearchLabelBackground.isHidden=false
                searchIconImageView.isHidden=true
            }
            self.layoutIfNeeded()
        }
    }
    
    public func setInitial(query:String){
        searchTextField.text = query
        switchToKeyboardHiddenMode() //updates constraints so that term is showing full width rather than just magnifying glass in the corner
    }
}
