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
            completionHandler(.performDefaultHandling, nil)
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
                let localCertificates = Self.localCertificates()
                let certificateNumber = SecTrustGetCertificateCount(serverTrust)
                for index in 0..<certificateNumber {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, index) {
                        let serverCertificateRawData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateRawData)
                        let size = CFDataGetLength(serverCertificateRawData)
                        let serverCertificateData = NSData(bytes: data, length: size) as Data
                        if localCertificates.contains(where: { serverCertificateData == $0 }) {
                            let credential = URLCredential(trust: serverTrust)
                            completionHandler(.useCredential, credential)
                            return
                        }
                    }
                }
            } 
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
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