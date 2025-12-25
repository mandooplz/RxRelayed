//
//  UserBoardViewController.swift
//  UserBoard
//
//  Created by 김민우 on 12/25/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit



// MARK: ViewController
final class UserBoardViewController: ViewController, UITableViewDelegate {
    // MARK: core
    private let userBoard = UserBoard()
    private let disposeBag = DisposeBag()
    
    private func connectModel() {
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe { [weak self] _ in
                self?.userBoard.createForm()
            }
            .disposed(by: self.disposeBag)
        
        self.userBoard.$users
            .drive { [weak self] users in
                self?.applySnapshot(with: users)
            }
            .disposed(by: self.disposeBag)
        
        self.userBoard.$userForm
            .drive { [weak self] userForm in
                if let userForm {
                    let vc = CreateUserFormViewController(userForm: userForm)
                    self?.present(vc, animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    
    // MARK: body
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: UserDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        configureDataSource()
        connectModel()
    }
    
    internal func setUpUI() {
        self.title = "샘플 테이블"
        view.backgroundColor = .systemBackground
        
        
        // NavigationItem의 우측 버튼을 지정
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Delegate를 self로 설정
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
    }
    
    private func configureDataSource() {
        self.dataSource = UserDataSource(
            tableView: self.tableView,
            cellProvider: { tableView, indexPath, user in
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = user.name
            cell.contentConfiguration = content
                
            return cell
        })
    }
    
    private func applySnapshot(with users: [UserBoard.MyUser]) {
        var snapshot = NSDiffableDataSourceSnapshot<UserBoard.UserType, UserBoard.MyUser>()
        
        // Enum에 정의된 순서대로 섹션 추가 (.vip, .regulat)
        snapshot.appendSections(UserBoard.UserType.allCases)
        
        let vips = users.filter { $0.type == .vip }
        let regulars = users.filter { $0.type == .regular }
        
        snapshot.appendItems(vips, toSection: UserBoard.UserType.vip)
        snapshot.appendItems(regulars, toSection: UserBoard.UserType.regular)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: DataSource
final class UserDataSource: UITableViewDiffableDataSource<UserBoard.UserType, UserBoard.MyUser> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKind = self.snapshot().sectionIdentifiers[section]
        return sectionKind.title
    }
}


// MARK: Preview
#Preview {
    UINavigationController(rootViewController: UserBoardViewController())
}
