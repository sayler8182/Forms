//
//  ConsoleWriter.swift
//  FormsDeveloperTools
//
//  Created by Konrad on 5/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: ConsoleWriter
internal class ConsoleWriter {
    internal let pipe = Pipe()
    internal var ignore: [String] = []
    
    internal var writingFileDescriptor: Int32 {
        return self.pipe.fileHandleForWriting.fileDescriptor
    }
    
    internal func write(content data: Data) {
        guard let content: String = String(data: data, encoding: .utf8) else {
            self.pipe.fileHandleForWriting.write(data)
            return
        }
        guard self.ignore.allSatisfy({ !content.contains($0) }) else { return }
        self.pipe.fileHandleForWriting.write(data)
    }
}
