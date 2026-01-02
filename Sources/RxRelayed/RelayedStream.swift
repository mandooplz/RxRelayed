//
//  RelayedStream.swift
//  RxRelayed
//
//  Created by 김민우 on 1/2/26.
//
import RxCombine
import RxCocoa
import RxSwift
import Combine


/// Rx와 Combine 스트림을 선택적으로 제공하는 Proxy 구조체
public struct RelayedStream<T> {
    private let relay: BehaviorRelay<T>
    
    init(relay: BehaviorRelay<T>) {
        self.relay = relay
    }
    
    /// RxSwift의 Driver 반환
    public var driver: Driver<T> {
        return relay.asDriver()
    }
    
    /// RxCombine을 활용하여 BehaviorRelay를 Combine Publisher로 즉시 변환
    public var publisher: AnyPublisher<T, Never> {
        return relay.asObservable()
            .asPublisher() // RxCombine의 확장 메서드
            .catch { _ in Empty<T, Never>() } // 에러 타입 일치 (Never)
            .eraseToAnyPublisher()
    }
}
