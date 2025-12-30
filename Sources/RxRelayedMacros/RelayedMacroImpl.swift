//
//  RelayedMacroImpl.swift
//  RxRelayed
//
//  Created by 김민우 on 12/30/25.
//
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct RelayedMacroImpl: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        // 1. 선언이 변수(var)인지 확인하고 이름과 타입을 추출합니다.
        guard let variable = declaration.as(VariableDeclSyntax.self),
              let binding = variable.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
              let typeAnnotation = binding.typeAnnotation else {
            return []
        }

        let originalName = identifier.identifier.text // 예: title
        let type = typeAnnotation.type.trimmedDescription // 예: String
        
        // 2. 새로운 이름 생성 (title -> observeTitle)
        let capitalizedName = originalName.prefix(1).uppercased() + originalName.dropFirst()
        let observerName = "tracked\(capitalizedName)"

        // 3. 생성할 코드 작성
        // @Relayed의 projectedValue($title)를 Driver로 반환하는 계산된 프로퍼티입니다.
        let generatedProperty: DeclSyntax = """
        public var \(raw: observerName): \(raw: type) {
            return \(raw: originalName)
        }
        """

        return [generatedProperty]
    }
}
