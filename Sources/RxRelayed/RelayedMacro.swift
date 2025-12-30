//
//  RelayedMacro.swift
//  RxRelayed
//
//  Created by 김민우 on 12/30/25.
//
import Foundation

/// 프로퍼티 옆에 `observe<Name>` 형태의 Driver를 자동으로 생성합니다.
/// 반드시 `@Relayed`와 함께 사용해야 합니다.
@attached(peer, names: arbitrary)
public macro Relayed() = #externalMacro(module: "RxRelayedMacros", type: "RelayedMacroImpl")
