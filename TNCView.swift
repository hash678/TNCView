//
//  CheckBoxView.swift
//  CircleViewTransitionApp
//
//  Created by Hassan Abbasi on 20/05/2020.
//  Copyright © 2020 Hassan Abbasi. All rights reserved.
//

import Foundation
import UIKit

typealias CustomError =  (() -> Void)

class TNCView:UIView{
    
    
    //Custom tick mark image
    var tickImage:UIImage?{
        didSet{
            check.image = tickImage
        }
    }
    
    //Custom error display.
    var customError:CustomError?
    
    private(set) var checked = false
    
    var animationDuration:Double = 0.5
    var errorAlertTitle = "Error"
    var errorAlertDesc = "Please accept the terms and conditions to proceed."
    
   
    //Black overlay for terms and conditions alpha.
    var blackOverlayAlpha:CGFloat = 0.8
    
    //Terms and conditions popup
    var termsandconditionTextColor:UIColor = .black
    var termsandconditionsFont = UIFont.systemFont(ofSize: 14)
    
    //Checkbox color
    var checkBoxPrimaryColor:UIColor = .black{
        didSet{
            self.checkBox.layer.borderColor = self.checkBoxPrimaryColor.cgColor
            self.check.tintColor = checkBoxPrimaryColor
            
        }
    }
    
    //View terms button color
    var termsAndConditionsButtonColor:UIColor = .blue{
        didSet{
            viewTerms.textColor = termsAndConditionsButtonColor
        }
    }
    
    //Terms label color
    var termsandconditionLabelColor:UIColor = .black{
         didSet{
             termsText.textColor = termsandconditionLabelColor
         }
     }
    //Terms label and button font
    var termsButtonFont:UIFont = UIFont.systemFont(ofSize: 14)

    
    
    var termsandconditionsText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
    
    weak var viewController:UIViewController?
    
    
    fileprivate lazy var checkBox:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.borderWidth = 3
        v.layer.borderColor = checkBoxPrimaryColor.cgColor
        v.backgroundColor = .white
        return v
    }()
    
    fileprivate lazy var check:UIImageView = {
        let l = UIImageView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.image = UIImage(named: "tickMark")?.withRenderingMode(.alwaysTemplate)
        l.tintColor = checkBoxPrimaryColor
        return l
    }()

 
    
    
    fileprivate lazy var termsText:UILabel = {
          let l = UILabel()
        l.textColor = termsandconditionLabelColor
        l.font = termsButtonFont
        l.text = "I accept the "
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
      }()
    
    fileprivate lazy var viewTerms:UILabel = {
          let l = UILabel()
        l.textColor = termsAndConditionsButtonColor
        l.font = termsButtonFont
        l.text = "Terms and conditions"
        l.textAlignment = .left
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isUserInteractionEnabled = true
        

        return l
      }()
  
    

    
    init(viewController:UIViewController,frame: CGRect) {
        super.init(frame:frame)
        self.viewController = viewController
        setupViews()

    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
 
    
    
  @objc fileprivate func onTap(){
    
    checked.toggle()
    checkBox.isUserInteractionEnabled = false
    UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
        self.updateCheck()
    }) { (_) in
        self.checkBox.isUserInteractionEnabled = true
    }
    
    }
    
    func verifyCheck(with completion:() -> Void){
        if checked{
            completion()
            return
        }
        
        if let vc = self.viewController{
            
            showError(vc: vc)
        }
    }
    
   fileprivate func showError(vc:UIViewController){
    if customError != nil{
        customError!()
        return
    }
    
        let alert = UIAlertController(title: errorAlertTitle, message: errorAlertDesc, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    @objc fileprivate func showTermsAndConditions(){
        viewTerms.addOnTapAnimation { (_) in
            if let v = self.viewController?.view{
                   let tView = TermsDisplay()
                tView.setPrimaryFont(self.termsandconditionsFont)
                tView.setPrimaryTextColor(self.termsandconditionTextColor)
                tView.setTerms(self.termsandconditionsText)
                tView.animationDuration = self.animationDuration
                tView.blackOverlayAlpha = self.blackOverlayAlpha
                       tView.addToView(mainView: v)
                       
                   }
        }
       
    }

}
//MARK: View setup
extension TNCView{
    
    fileprivate func updateCheck(){
        self.check.transform = self.checked ? CGAffineTransform(scaleX: 1, y: 1) : CGAffineTransform(scaleX: 0.01, y: 0.01)
               self.check.alpha = self.checked ? 1 : 0
    }
    
      override func layoutSubviews() {
          super.layoutSubviews()
          checkBox.layer.cornerRadius = checkBox.frame.width / 2
          self.updateCheck()
      }
    
    fileprivate func setupViews(){
        self.addSubview(checkBox)
        checkBox.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(termsText)
              termsText.leftAnchor.constraint(equalTo: checkBox.rightAnchor,constant: 8).isActive = true
              termsText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       
        self.addSubview(viewTerms)
              viewTerms.leftAnchor.constraint(equalTo: termsText.rightAnchor).isActive = true
              viewTerms.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        checkBox.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        checkBox.widthAnchor.constraint(equalTo: checkBox.heightAnchor, multiplier: 1).isActive = true
        
        
        checkBox.addSubview(check)

        
        check.heightAnchor.constraint(equalTo: checkBox.heightAnchor, multiplier: 0.6).isActive = true
        
        
        check.widthAnchor.constraint(equalTo: checkBox.widthAnchor, multiplier: 0.6).isActive = true
        
               check.centerXAnchor.constraint(equalTo: checkBox.centerXAnchor).isActive = true
                       check.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor).isActive = true
        
        
        checkBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
            viewTerms.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTermsAndConditions)))
    }
    
}

//MARK: Terms and conditions popup view.
fileprivate class TermsDisplay:UIView {
    
    fileprivate var animationDuration:Double = 1.0
    fileprivate var blackOverlayAlpha:CGFloat = 0.8
   fileprivate func setPrimaryFont(_ font:UIFont){
        title.font = font
        closeButton.titleLabel?.font = font
    }
    
  fileprivate  func setPrimaryTextColor(_ color:UIColor){
           title.textColor = color
            closeButton.setTitleColor(color, for: .normal)
       }
         
        override init(frame: CGRect) {
        super.init(frame:frame)
                   setupViews()
               }
           
               required init?(coder: NSCoder) {
                   fatalError("init(coder:) has not been implemented")
               }
           
        
        fileprivate lazy var background:UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .black
            v.alpha = self.blackOverlayAlpha
            return v
        }()
        
      
        fileprivate lazy var mainBox:UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .white
            
            return v
        }()
        
        fileprivate lazy var closeButton:UIButton = {
            let v = UIButton()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.isUserInteractionEnabled = true
            v.setTitle("Close", for: .normal)
            v.setTitleColor(.black, for: .normal)
            return v
        }()
        
    
    
    fileprivate lazy var title:UILabel = {
          let l = UILabel()
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 12)
        l.text = "Terms and Conditions"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
      }()
    
    fileprivate lazy var mainTextLabel:UILabel = {
          let l = UILabel()
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 12)
        l.text = ""
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = -1
        l.textAlignment = .justified
        return l
      }()
   
    
    func setTerms(_ terms:String){
        mainTextLabel.text = terms
    }
    
   fileprivate func setupMainBox(){
        mainBox.addSubview(title)
        title.centerXAnchor.constraint(equalTo: self.mainBox.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: mainBox.topAnchor,constant: 8).isActive = true
        
        mainBox.addSubview(closeButton)
         closeButton.centerXAnchor.constraint(equalTo: self.mainBox.centerXAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: mainBox.bottomAnchor,constant: -8).isActive = true
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
   
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        mainBox.addSubview(scrollView)
        scrollView.widthAnchor.constraint(equalTo: mainBox.widthAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: mainBox.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 8).isActive = true
         scrollView.bottomAnchor.constraint(equalTo: closeButton.topAnchor,constant: -16).isActive = true
        
        scrollView.addSubview(mainTextLabel)
        mainTextLabel.widthAnchor.constraint(equalTo: mainBox.widthAnchor,multiplier: 0.9).isActive = true
        mainTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        mainTextLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
               mainTextLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
                           
    }
    
      
   fileprivate func setupViews(){
            
            
            
            self.addSubview(background)
            background.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            background.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            background.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            
            
            
            self.addSubview(mainBox)
            mainBox.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
            mainBox.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9).isActive = true
            mainBox.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            mainBox.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            setupMainBox()
            
        
        }
        
        @objc fileprivate func closeView(){
            
          
            UIView.animate(withDuration: 0.5, animations: {
                 //self.mainBox.alpha = 0
                self.alpha = 0
                               self.mainBox.transform = CGAffineTransform(translationX: 0, y: -500)
            }) { (_) in
                            self.removeFromSuperview()

            }
        }
      
        func addToView(mainView:UIView){
            self.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(self)
            self.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
            self.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
            self.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
    
            self.mainBox.alpha = 0
              self.mainBox.transform = CGAffineTransform(translationX: 0, y: -500)
            UIView.animate(withDuration: animationDuration) {
                self.mainBox.alpha = 1
                self.mainBox.transform = .identity
            }
    }
    
    
    
        
    }

extension UIView{
    func addOnTapAnimation(completion:((Bool) -> Void)? = nil){
          self.alpha = 0.25
          UIView.animate(withDuration: 0.5, animations: { [weak self] in
              self?.alpha = 1
          }, completion: completion)
      
      }
      
}
