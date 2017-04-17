//
//  Aes128.swift
//  MonoAD
//
//  Created by 찬누리 박 on 2017. 4. 17..
//  Copyright © 2017년 Monorama. All rights reserved.
//

import Foundation
import CryptoSwift


class Aes128
{
    let key = "monorama!Q2w3e4rmonorama!Q2w3e4r"
    let iv = "monorama!Q2w3e4r"
    
    //암호화
    func aesEncrypt(_ str : String) throws -> String{
        let data = str.data(using: String.Encoding.utf8)
        let enc = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(data!.bytes)
        let encData = Data(bytes: enc, count: Int(enc.count))
        let base64String: String = encData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        let result = String(base64String)
        return result!
    }
    
    //복호화
    func aesDecrypt(_ str : String) throws -> Data {
        let data = Data(base64Encoded: str, options: Data.Base64DecodingOptions(rawValue: 1))
        let dec = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(data!.bytes)
        let decData = Data(bytes: dec, count: dec.count)
        return decData
    }
}
