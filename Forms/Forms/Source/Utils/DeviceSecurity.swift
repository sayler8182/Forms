//
//  DeviceSecurity.swift
//  Forms
//
//  Created by Konrad on 8/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import Foundation
import UIKit

// MARK: DeviceSecurity
public class DeviceSecurity {
    public var isSecure: Bool {
        let items: [String] = [
            "hLG3ByaXZhdGUvdmFyL3N0YXNo",
            "hLG3ByaXZhdGUvdmFyL2xpYi9hcHQ ",
            "hLG3ByaXZhdGUvdmFyL3RtcC9jeWRpYS5sb2c ",
            "hLG3ByaXZhdGUvdmFyL2xpYi9jeWRpYQ  ",
            "hLG3ByaXZhdGUvdmFyL21vYmlsZS9MaWJyYXJ5L1NCU2V0dGluZ3MvVGhlbWVz",
            "hLn0xpYnJhcnkvTW9iaWxlU3Vic3RyYXRlL01vYmlsZVN1YnN0cmF0ZS5keWxpYg  ",
            "hLn0xpYnJhcnkvTW9iaWxlU3Vic3RyYXRlL0R5bmFtaWNMaWJyYXJpZXMvVmVlbmN5LnBsaXN0",
            "hLn0xpYnJhcnkvTW9iaWxlU3Vic3RyYXRlL0R5bmFtaWNMaWJyYXJpZXMvTGl2ZUNsb2NrLnBsaXN0",
            "lLS1N5c3RlbS9MaWJyYXJ5L0xhdW5jaERhZW1vbnMvY29tLmlrZXkuYmJvdC5wbGlzdA  ",
            "lLS1N5c3RlbS9MaWJyYXJ5L0xhdW5jaERhZW1vbnMvY29tLnNhdXJpay5DeWRpYS5TdGFydHVwLnBsaXN0",
            "jLW3Zhci9jYWNoZS9hcHQ ",
            "sLW3Zhci9saWIvYXB0",
            "sLW3Zhci9saWIvY3lkaWE ",
            "sL23Zhci9sb2cvc3lzbG9n",
            "0LX3Zhci90bXAvY3lkaWEubG9n",
            "iLX2Jpbi9iYXNo",
            "zLA2Jpbi9zaA  ",
            "zLm3Vzci9zYmluL3NzaGQ ",
            "sLW3Vzci9saWJleGVjL3NzaC1rZXlzaWdu",
            "zLm3Vzci9zYmluL3NzaGQ ",
            "iLW3Vzci9iaW4vc3NoZA  ",
            "sLW3Vzci9saWJleGVjL3NmdHAtc2VydmVy",
            "zL22V0Yy9zc2gvc3NoZF9jb25maWc ",
            "hLH2V0Yy9hcHQ ",
            "pL20FwcGxpY2F0aW9ucy9DeWRpYS5hcHA ",
            "hLn0xpYnJhcnkvTW9iaWxlU3Vic3RyYXRlL01vYmlsZVN1YnN0cmF0ZS5keWxpYg  "
        ]
        
        let unauthorizedAccess = [
            self.canOpen,
            self.exist,
            self.canRead,
            self.canWrite
            ]
            .flatMap { check in items.map { check($0) } }
            .contains(true)
        
        let containsCydia = [
            "aYE3lkaWE ",
            "MdZW5jMHZlcg  "
            ]
            .map { self.contains($0) }
            .contains(true)
        
        return unauthorizedAccess || containsCydia
    }
    
    private func canOpen(_ path: String) -> Bool {
        guard let url: URL = path.url else { return false }
        guard UIApplication.shared.canOpenURL(url) else { return false }
        return true
    }
    
    private func exist(_ path: String) -> Bool {
        guard let path: String = path._secureDecoding() else { return true }
        return FileManager.default.fileExists(atPath: path)
    }
    
    private func canRead(_ path: String) -> Bool {
        guard let path: String = path._secureDecoding() else { return true }
        let file = fopen(path, "r")
        guard file.isNotNil else { return false }
        fclose(file)
        return true
    }
    
    private func canWrite(_ path: String) -> Bool {
        guard let path: String = path._secureDecoding() else { return true }
        do {
            try path.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    private func contains(_ path: String) -> Bool {
        guard let path: String = path._secureDecoding() else { return true }
        let contains: Bool? = try? FileManager.default.contentsOfDirectory(atPath: "/").contains(path)
        return contains ?? false
    }
}

private extension String {
    func _secureDecoding() -> String? {
        var string: String = self
        string.removeFirst()
        string.remove(at: string.index(after: string.startIndex))
        string = string.replacingOccurrences(of: " ", with: "=")
        let newString: String? = string.fromBase64()
        return newString
    }
}
