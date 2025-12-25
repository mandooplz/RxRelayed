//
//  CreateUserFormViewController.swift
//  UserBoard
//
//  Created by 김민우 on 12/25/25.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit


// MARK: ViewController
@MainActor
final class CreateUserFormViewController: UIViewController {
    // MARK: core
    let userForm: CreateUserForm
    private let disposeBag = DisposeBag()
    
    init(userForm: CreateUserForm) {
        self.userForm = userForm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
    }
    
    
    // MARK: body
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 멤버 정보를 입력해주세요"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이름"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    private let typeSegmentedControl = UISegmentedControl(items: UserBoard.UserType.allCases.map(\.title))
    
    private let submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "등록하기"
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .medium
        
        let btn = UIButton(configuration: config)
        btn.isEnabled = false // 초기값 비활성화
        return btn
    }()
    
    
    // MARK: helpher
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        self.title = "멤버 추가"
        
        // Navigation BarItem에 닫기 버튼 추가
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, nameTextField, typeSegmentedControl, submitButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top
                .equalTo(self.view.safeAreaLayoutGuide)
                .offset(30)
            
            make.leading.trailing
                .equalToSuperview()
                .inset(24)
        }
        
        submitButton.snp.makeConstraints { make in
            make.height
                .equalTo(54)
        }
    }
    
    private func bindViewModel() {
        // 이름 입력
        nameTextField.rx.text.orEmpty
            .subscribe { [weak self] text in
                self?.userForm.nameInput = text
                self?.userForm.validate()
            }
            .disposed(by: disposeBag)
        
        // 타입 입력
        typeSegmentedControl.rx.selectedSegmentIndex
            .filter { $0 != -1 }
            .map { $0 == 0 ? UserBoard.UserType.vip : .regular }
            .subscribe { [weak self] userType in
                self?.userForm.typeInput = userType
                self?.userForm.validate()
            }
            .disposed(by: disposeBag)
        
        // 제출 버튼
        self.userForm.$isValid
            .drive(submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .subscribe { [weak self] _ in
                self?.userForm.submit()
            }
            .disposed(by: disposeBag)
        
        // 취소 버튼
        self.navigationItem.leftBarButtonItem?.rx.tap
            .subscribe { [weak self] _ in
                self?.userForm.cancel()
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.userForm.cancel()
    }
}
