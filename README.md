# RxRelayed

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange?style=flat-square)](https://swift.org)
[![RxSwift](https://img.shields.io/badge/RxSwift-6.0+-red?style=flat-square)](https://github.com/ReactiveX/Swift)
[![Platform](https://img.shields.io/badge/Platforms-iOS%2013.0+-lightgrey?style=flat-square)](https://apple.com)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)

**RxRelayed** is a lightweight Swift Property Wrapper that eliminates boilerplate code when using `BehaviorRelay` and `Driver` in RxSwift. It allows you to handle state as a standard property while maintaining the power of reactive streams.

---

## 🚀 Features

* **Zero Boilerplate**: No more manual `_relay` and `asDriver()` declarations.
* **Property-like Syntax**: Mutate and access values directly using the `=` operator.
* **Automatic Projection**: Access the `Driver` stream instantly using the `$` prefix.
* **Thread-Safe**: Built on top of `BehaviorRelay` for safe state management.

---

## 📦 Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "[https://github.com/mandooplz/RxRelayed.git](https://github.com/mandooplz/RxRelayed.git)", from: "1.0.0")
]
```

---

## 💻 Usage

### 1. In your ViewModel

Simplify your state declarations using the `@Relayed` wrapper.

```swift
import RxRelayed

final class UserViewModel {
    // Declares a BehaviorRelay with an initial value
    @Relayed var userName: String = "Guest"
    @Relayed var isVip: Bool = false
    
    func updateName(to newName: String) {
        // Direct mutation (calls .accept() internally)
        userName = newName
    }
}
```

### 2. In your ViewController

Use the `$` prefix to access the Driver for UI binding.

```swift
import RxSwift
import RxCocoa

final class UserViewController: UIViewController {
    private let viewModel = UserViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use '$' to bind the projected Driver
        viewModel.$userName
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
            
        viewModel.$isVip
            .drive(vipBadge.rx.isHidden.map { !$0 })
            .disposed(by: disposeBag)
    }
}
```

--- 

## 🛠 Requirements

- iOS 13.0+
- Swift 5.9+
- RxSwift 6.0+
