//
//  Plugin.swift
//  RxRelayed
//
//  Created by 김민우 on 12/30/25.
//
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct RxRelayedPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RelayedMacroImpl.self
    ]
}
