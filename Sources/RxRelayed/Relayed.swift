import Foundation
import RxSwift
import RxCocoa

/// A property wrapper that simplifies the use of `BehaviorRelay` and `Driver`.
///
/// It allows you to interact with a reactive state as a normal property while
/// providing easy access to its `Driver` stream using the `$` prefix.
///
/// ### Example Usage
/// ```swift
/// final class MyViewModel {
///     // 1. Declare a reactive property
///     @Relayed var title: String = "Hello"
///
///     func updateTitle() {
///         // 2. Set value like a normal variable (calls .accept() internally)
///         title = "World"
///     }
/// }
///
/// // In ViewController
/// viewModel.$title
///     .drive(label.rx.text)
///     .disposed(by: disposeBag)
/// ```
@propertyWrapper
public struct Relayed<T> {
    
    /// Internal storage for the reactive state.
    private let relay: BehaviorRelay<T>
    
    /// The current value of the relay.
    ///
    /// Setting this value will automatically trigger an `.accept(_:)` call to the underlying relay.
    public var wrappedValue: T {
        get { relay.value }
        set { relay.accept(newValue) }
    }
    
    /// A `Driver` that emits the current and subsequent values of the relay.
    ///
    /// Use the `$` prefix to access the reactive stream.
    ///
    /// ```swift
    /// viewModel.$userName
    ///     .drive(label.rx.text)
    ///     .disposed(by: disposeBag)
    /// ```
    public var projectedValue: Driver<T> {
        return relay.asDriver()
    }
    
    /// Initializes the property wrapper with an initial value.
    ///
    /// - Parameter wrappedValue: The initial value to be stored in the relay.
    public init(wrappedValue: T) {
        self.relay = BehaviorRelay(value: wrappedValue)
    }
}
