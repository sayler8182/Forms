//
//  DemoMockViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import Mock
import UIKit

class DemoMockViewController: FormsTableViewController {
    private let reloadButton = Components.button.default()
        .with(title: "Reload")
    private let mockLabel = Components.label.default()
        .with(numberOfLines: 0)
        .with(paddingEdgeInset: UIEdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))

    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.reloadButton,
            self.mockLabel
        ], divider: self.divider)
        self.reloadMock()
    }
    
    override func setupActions() {
        super.setupActions()
        self.reloadButton.onClick = { [unowned self] in
            self.reloadMock()
            self.reloadData()
        }
    }
    
    private func reloadMock() {
        let model: DemoModel = DemoModel.mock()
        self.mockLabel.text = model.debugDescription
    }
}

// MARK: DemoModelStatus
private enum DemoModelStatus: CaseIterable {
    case active
    case inactive
}

// MARK: DemoModel
private struct DemoModel: Mockable, CustomDebugStringConvertible {
    let id: String
    let name: String
    let lastName: String
    let lastNameLong: String
    let email: String?
    let emailLong: String?
    let age: Int
    let height: Double
    let description: String
    let birthDate: Date
    let postCode: String
    let phone: String
    let isActive: Bool
    let status: DemoModelStatus
    let avatar: URL
    let subitems: [Int]
    
    init(_ mock: Mock) {
        self.id = mock.uuid()
        self.name = mock.name()
        self.lastName = mock.lastName()
        self.lastNameLong = mock.lastName([.length(.long)])
        self.email = mock.email(
            name: self.name,
            lastName: self.lastName,
            options: [.nullable(0.1)])
        self.emailLong = mock.email([.length(.long), .nullable(0.1)])
        self.age = mock.number(18...100)
        self.height = mock.number(1.5...1.99)
        self.description = mock.string([.length(.regular)])
        self.birthDate = mock.date(
            from: "1950-01-01 00:00",
            fromFormat: "yyyy-MM-dd HH:mm",
            to: "2000-12-31 23:59",
            toFormat: "yyyy-MM-dd HH:mm")
        self.postCode = mock.postCode(format: "DD-DDD")
        self.phone = mock.phone(
            prefix: "+48",
            length: 9,
            groupingSeparator: " ")
        self.isActive = mock.bool()
        self.status = mock.item(from: DemoModelStatus.allCases)
        self.avatar = mock.imageUrl()
        self.subitems = mock.array(of: mock.number(0..<10), count: 10)
    }
    
    var debugDescription: String {
        return """
        id:
        \(self.id)
        
        name:
        \(self.name)
        
        lastName:
        \(self.lastName)
        
        lastNameLong:
        \(self.lastNameLong)
        
        email:
        \(self.email.or("nil")),
        
        emailLong:
        \(self.emailLong.or("nil"))
        
        age:
        \(self.age.formatted(suffix: "y"))
        
        height:
        \(self.height.formatted(suffix: "m"))
        
        description:
        \(self.description)
        
        birthDate:
        \(self.birthDate.formatted(format: .date).or("nil"))
        \(self.birthDate.formatted(format: .time).or("nil"))
        \(self.birthDate.formatted(format: .full).or("nil"))
        
        postCode:
        \(self.postCode)
        
        phone:
        \(self.phone)
        
        isActive:
        \(self.isActive)
        
        status:
        \(self.status)
        
        avatar:
        \(self.avatar)
        
        subitems:
        \(self.subitems)
        
        """
    }
}
