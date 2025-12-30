//
//  UserBoard.swift
//  UserBoard
//
//  Created by 김민우 on 12/25/25.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelayed
import OSLog


// MARK: Object
@MainActor
public final class UserBoard: Sendable {
    // MARK: core
    private nonisolated let logger = Logger()
    public init() { }
    
    
    // MARK: state
    @Relayed var users: [MyUser] = [
        MyUser(name: "Alice", type: .vip),
        MyUser(name: "Bob", type: .regular),
        MyUser(name: "Charlie", type: .vip),
        MyUser(name: "David", type: .regular)
    ]
    
    @Relayed var userForm: CreateUserForm? = nil
    
    
    // MARK: action
    public func addRandomUser() {
        // process
        let newUser = MyUser(
            name: "User #\(self.users.count)",
            type: UserType.allCases.randomElement()!
        )
        
        // mutate
        self.users.append(newUser)
    }
    
    public func createForm() {
        // capture
        guard self.userForm == nil else {
            logger.error("이미 CreateUserForm이 존재합니다.")
            return
        }
        
        // mutate
        self.userForm = CreateUserForm(owner: self)
    }
    
    
    // MARK: value
    public nonisolated struct MyUser: Sendable, Hashable {
        let id = UUID()
        let name: String
        let type: UserType
    }
    
    public nonisolated enum UserType: CaseIterable, Sendable, Hashable {
        case vip
        case regular
        
        // operator
        var title: String {
            switch self {
            case .vip: return "VIP"
            case .regular: return "Regular"
            }
        }
    }
}
