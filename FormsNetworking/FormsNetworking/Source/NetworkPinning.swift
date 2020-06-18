//
//  NetworkPinning.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public enum NetworkPinning {
    public static var isEnabled: Bool = false
    public static var certificates: [URL] = []
    
    public static func validate(_ session: URLSession,
                                didReceive challenge: URLAuthenticationChallenge,
                                completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard Self.isEnabled else {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
            return
        }
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            let serverTrust: SecTrust = challenge.protectionSpace.serverTrust {
            var status: Bool = false
            if #available(iOS 12.0, *) {
                status = SecTrustEvaluateWithError(serverTrust, nil)
            } else {
                var result: SecTrustResultType = .invalid
                status = SecTrustEvaluate(serverTrust, &result) == errSecSuccess
            }
            if status {
                let localCertificates: [Data] = Self.localCertificates()
                let certificateNumber: CFIndex = SecTrustGetCertificateCount(serverTrust)
                for index in 0..<certificateNumber {
                    if let serverCertificate: SecCertificate = SecTrustGetCertificateAtIndex(serverTrust, index) {
                        let serverCertificateRawData: CFData = SecCertificateCopyData(serverCertificate)
                        let data: UnsafePointer<UInt8>? = CFDataGetBytePtr(serverCertificateRawData)
                        let size: CFIndex = CFDataGetLength(serverCertificateRawData)
                        let serverCertificateData: Data = NSData(bytes: data, length: size) as Data
                        if localCertificates.contains(where: { serverCertificateData == $0 }) {
                            let credential: URLCredential = URLCredential(trust: serverTrust)
                            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
                            return
                        }
                    }
                }
            } 
        }
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    
    private static func localCertificates() -> [Data] {
        var data: [Data] = []
        for certificate in Self.certificates {
            guard let certificateData = try? Data(contentsOf: certificate) else { continue }
            data.append(certificateData)
        }
        return data
    }
}
