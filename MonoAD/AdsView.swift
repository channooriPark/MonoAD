//
//  AdsView.swift
//  MonoAD
//
//  Created by 찬누리 박 on 2017. 4. 17..
//  Copyright © 2017년 Monorama. All rights reserved.
//

import UIKit

class AdsView : UIView {
    let viewFrame : CGRect = (UIApplication.shared.keyWindow?.frame)!
    var cancelBtn : UIButton!
    var adsImage : UIImageView!
    var linkBtn : UIButton!
    let serverAddr : String = "http://192.168.1.89/Api/"
    
    let imgAddr : String = "http://192.168.1.89/uploaded/"
    var link : String?
    var appId : String?
    var clickCheck : Bool = false
    
    
    init() {
        super.init(frame: viewFrame)
        self.frame = CGRect(x: 10, y: 74, width: viewFrame.size.width-20, height: viewFrame.size.height-144)
        self.backgroundColor = UIColor.black
        setView()
    }
    
    func setView() {
        
        
        print("inside AdsViews this view frame is ",self.frame)
        
        
        
        
        let orientation = UIApplication.shared.statusBarOrientation
        var imageViewFrame : CGRect!
        var btnFrame : CGRect!
        
        adsImage = UIImageView()
        if orientation == UIInterfaceOrientation.portrait {
            print("세로 화면이야")
            let height : CGFloat = (self.frame.size.width/16)*9
            let posY : CGFloat = (self.frame.size.height/2)-(height/2)
            imageViewFrame = CGRect(x: 0, y: posY, width: self.frame.size.width, height: height)
            //imageViewFrame = self.viewFrame
            btnFrame = CGRect(x: self.frame.size.width-40, y: 10, width: 30, height: 30)
            
            
        }else {
            imageViewFrame = self.viewFrame
            self.adsImage.transform = self.adsImage.transform.rotated(by: CGFloat(M_PI_2))
            btnFrame = CGRect(x: self.frame.size.width-40, y: self.frame.size.height-35, width: 30, height: 30)
        }
        
        adsImage.frame = imageViewFrame
        
        cancelBtn = UIButton(frame: btnFrame)
        cancelBtn.backgroundColor = UIColor.lightGray
        cancelBtn.setImage(UIImage(named: "cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(AdsView.pressCancel(_:)), for: .touchUpInside)
        cancelBtn.layer.cornerRadius = 5
        
        
        let requestData = Util().createJSON(serviceKey: "!Q2w3e4r", data: [])
        Util().requestJSON(requestData, apiType: "getImgAddr") { (result) in
            let imgUrl = (self.imgAddr + result["data"][0]["img"].stringValue).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let linkStr = result["data"][0]["app_id"].string
            {
                self.link = linkStr
                self.appId = result["data"][0]["id"].stringValue
            }else {
                self.link = nil
            }
            self.downloadImage(url: URL(string: imgUrl!)!) { (image) in
                DispatchQueue.main.async() { () -> Void in
                    self.adsImage.image = image
                    //calling count up API
                    if let id = result["data"][0]["id"].string
                    {
                        Util().requestJSON(Util().createJSON(serviceKey: "!Q2w3e4r", data: [id]), apiType: "showCount", callback: { (result) in
                            print("showCount complete")
                        })
                    }
                    
                }
            }
        }
        
        
        
        linkBtn = UIButton(frame: self.frame)
        linkBtn.addTarget(self, action: #selector(AdsView.pressLink(_:)), for: .touchUpInside)
        //        linkBtn.isEnabled = false
        print("false")
        
        self.addSubview(adsImage)
        self.addSubview(linkBtn)
        self.addSubview(cancelBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImage(url: URL, calback: @escaping(UIImage) -> ()){
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let imgData = data, error == nil else { print(error!)
                return}
            if let img = UIImage(data: imgData) {
                calback(img)
            }
        }
        
    }
    
    //async down image file
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error == nil && data != nil && response != nil {
                completion(data, response, error)
            }
            }.resume()
    }
    
    func pressCancel(_ sender : UIButton) {
        self.removeFromSuperview()
    }
    
    func pressLink(_ sender : UIButton) {
        if self.link != nil && !(self.link?.isEmpty)! {
            UIApplication.shared.open(URL(string: "https://itunes.apple.com/app/id\(self.link!)")!, options: ["":""]) { (result) in
                if result {
                    if self.appId != nil && !self.clickCheck{
                        self.clickCheck = true
                        Util().requestJSON(Util().createJSON(serviceKey: "!Q2w3e4r", data: [self.appId!]), apiType: "clickCount", callback: { (result) in
                            print("clickCount complete")
                        })
                    }
                    
                }
            }
        }
    }
}
