//
//  Reachability.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import SystemConfiguration

public enum Reachability {
    static var isConnected: Bool {
        var address = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        address.sin_len = UInt8(MemoryLayout.size(ofValue: address))
        address.sin_family = sa_family_t(AF_INET)
        guard let reachability = withUnsafePointer(to: &address, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { addr in
                SCNetworkReachabilityCreateWithAddress(nil, addr)
            }
        }) else { return false }
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        guard SCNetworkReachabilityGetFlags(reachability, &flags) else { return false }
        let isReachable = flags.rawValue & UInt32(kSCNetworkFlagsReachable) != 0
        let connectionRequired = flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired) != 0
        return isReachable && !connectionRequired
    }
}
