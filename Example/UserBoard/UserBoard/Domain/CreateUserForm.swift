//
//  CreateUserForm.swift
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
public final class CreateUserForm: Sendable {
    // MARK: core
    private nonisolated let logger = Logger()
    public init(owner: UserBoard) {
        self.owner = owner
    }
    
    
    // MARK: state
    private weak var owner: UserBoard?
    
    @Relayed public var nameInput: String = ""
    @Relayed public var typeInput: UserBoard.UserType? = nil
    
    @Relayed public var isValid: Bool = false
    
    
    // MARK: action
    public func validate() {
        // process
        let nameInputIsNotEmpty = (self.nameInput.isEmpty == false)
        let typeInputIsNotNil = (self.typeInput != nil)
        
        let isValid = nameInputIsNotEmpty && typeInputIsNotNil
        
        // mutate
        self.isValid = isValid
        logger.debug("isValid: \(isValid)")
    }
    public func submit() {
        // capture
        guard self.isValid else {
            logger.error("유효성 검증을 통과하지 못했습니다. validate()을 먼저 호출해주세요")
            return
        }
        
        let nameInput = self.nameInput
        let typeInput = self.typeInput!
        let userBoard = self.owner!
        
        // process
        let newUser = UserBoard.MyUser(
            name: nameInput,
            type: typeInput
        )
        
        // mutate
        userBoard.users.append(newUser)
        userBoard.userForm = nil
    }
    public func cancel() {
        // capture
        let userBoard = self.owner
        
        // mutate
        userBoard?.userForm = nil
    }
    
    
    // MARK: value
    
}
