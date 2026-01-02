import Foundation
import RxSwift
import RxCocoa
import Combine

/// A reactive property wrapper that bridges **RxSwift streams** with **SwiftUI state updates**.
///
/// `Relayed` is designed for `ObservableObject` types and uses the *Enclosing Instance* pattern
/// to notify SwiftUI (`objectWillChange`) while simultaneously propagating changes through
/// `BehaviorRelay`.
///
/// Direct access to `wrappedValue` is intentionally disabled; reads and writes must go through
/// the enclosing instance so lifecycle notifications remain consistent.
///
/// ---
/// ### Usage Example
///
/// ```swift
/// final class ProfileViewModel: ObservableObject {
///
///     @Relayed var name: String = "Minwoo"
///     @Relayed var age: Int = 20
///
///     func updateProfile() {
///         // Triggers objectWillChange + relay.accept(_:)
///         name = "Kim Minwoo"
///         age += 1
///     }
/// }
/// ```
///
/// #### Observing in UIKit (RxSwift)
/// ```swift
/// viewModel.$name
///     .drive(nameLabel.rx.text)
///     .disposed(by: disposeBag)
/// ```
///
/// #### Observing in SwiftUI
/// ```swift
/// struct ProfileView: View {
///     @StateObject var viewModel = ProfileViewModel()
///
///     var body: some View {
///         Text(viewModel.name)
///     }
/// }
/// ```
///
/// - Note: Value mutations notify SwiftUI *before* emitting to Rx streams,
///         ensuring consistent UI updates across UIKit and SwiftUI.
@propertyWrapper
public struct Relayed<T> {

    /// Internal storage for the reactive state.
    ///
    /// Backed by `BehaviorRelay` so it always has a current value.
    private var relay: BehaviorRelay<T>

    /// Initializes the property wrapper with an initial value.
    ///
    /// - Parameter wrappedValue: The initial value to be stored in the relay.
    public init(wrappedValue: T) {
        self.relay = BehaviorRelay(value: wrappedValue)
    }

    /// Exposes the reactive stream using the `$` prefix.
    ///
    /// This is the primary way to observe changes.
    ///
    /// ```swift
    /// viewModel.$userName
    ///     .drive(label.rx.text)
    ///     .disposed(by: disposeBag)
    /// ```
    public var projectedValue: RelayedStream<T> {
        RelayedStream(relay: relay)
    }

    /// Direct access is intentionally disallowed.
    ///
    /// This wrapper is designed to be used with the *Enclosing Instance* pattern
    /// so it can notify `ObservableObject.objectWillChange` before emitting a new value.
    @available(*, unavailable)
    public var wrappedValue: T {
        get { fatalError("Direct access is unavailable. Use the enclosing-instance subscript.") }
        set { fatalError("Direct access is unavailable. Use the enclosing-instance subscript.") }
    }

    /// Core: bridges value writes into both Rx streams and SwiftUI updates.
    ///
    /// - Notifies `objectWillChange` (when available) *before* updating the underlying relay.
    /// - Updates the `BehaviorRelay` to propagate changes downstream.
    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance instance: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Relayed<T>>
    ) -> T {
        get {
            instance[keyPath: storageKeyPath].relay.value
        }
        set {
            // 1) Notify SwiftUI that a change is about to happen (ObservableObject only)
            if let publisher = instance.objectWillChange as? ObservableObjectPublisher {
                publisher.send()
            }

            // 2) Update the actual value (propagates through Rx/Combine streams)
            instance[keyPath: storageKeyPath].relay.accept(newValue)
        }
    }
}
