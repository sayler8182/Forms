//
//  AutolayoutWriter.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: AutolayoutWriter
internal class AutolayoutWriter {
    private let pipe = Pipe()
    
    internal var writingFileDescriptor: Int32 {
        return self.pipe.fileHandleForWriting.fileDescriptor
    }
    
    internal func write(content: Data) {
        return self.pipe.fileHandleForWriting.write(content)
    }
}
