//
//  AutolayoutReader.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: AutolayoutReader
internal class AutolayoutReader {
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
