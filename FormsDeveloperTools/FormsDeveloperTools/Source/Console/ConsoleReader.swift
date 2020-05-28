//
//  ConsoleReader.swift
//  FormsDeveloperTools
//
//  Created by Konrad on 5/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: ConsoleReader
internal class ConsoleReader {
    private let pipe: Pipe = Pipe()
    
    internal var writingFileDescriptor: Int32 {
        return self.pipe.fileHandleForWriting.fileDescriptor
    }
    internal var readingFileDescriptor: Int32 {
        return self.pipe.fileHandleForReading.fileDescriptor
    }

    internal func read() -> Data {
        return self.pipe.fileHandleForReading.availableData
    }
}
