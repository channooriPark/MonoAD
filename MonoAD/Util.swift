//
//  Util.swift
//  MonoAD
//
//  Created by 찬누리 박 on 2017. 4. 17..
//  Copyright © 2017년 Monorama. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Util
{
    let aes = Aes128()
    let serverAddr = "http://192.168.1.89/Api/"
    
    public func createJSON(serviceKey : String, data:[String]) -> JSON {
        let message : JSON = ["serviceKey":serviceKey,"data":data]
        return message
    }
    
    func requestJSON(_ message: JSON, apiType: String, callback: @escaping(JSON)-> ())
    {
        var str = String(describing: message)
        do {
            str = try self.aes.aesEncrypt(str)
            
        }catch let e{
            print("Error = ",e)
        }
        
        
        
        //Alamofire.request("\(self.youtubeURL)", method: .post,parameters: ["data":str]).validate().
        Alamofire.request("\(self.serverAddr)\(apiType)", method: .post,parameters: ["data":str]).validate().responseString { (response) in
            if let value = response.result.value {
                do {
                    print(value)
                    let json = JSON(data: try self.aes.aesDecrypt(value))
                    print("json",json)
                    callback(json)
                }catch let error{
                    print(error)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
}
