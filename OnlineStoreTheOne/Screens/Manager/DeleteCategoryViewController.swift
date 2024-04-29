//
//  DeleteCategoryViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit
import Combine

final class DeleteCategoryViewController: UIViewController {
    
    //MARK: - Private Properties
    private let viewModel = DeleteCategoryViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    private let categoryView = ContainerManagersView(type: .deleteCategory)
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    
    private lazy var saveButton = FilledButtonFactory(
        title: "Delete",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            guard let self else { return }
            Task {
                await self.deleteCategory()
            }
            navigationController?.popViewController(animated: true)
        })
    ).createButton()
    
    private lazy var cancelButton = FilledButtonFactory(
        title: "Cancel",
        type: .grayButton,
        action: UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
    ).createButton()
    
    private lazy var buttonsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 30
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private lazy var foundCategoryTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Category found:"
        $0.font = .makeTypography(.bold, size: 18)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var idCategoryTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "ID:"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var idCategoryLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "_"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var idLabelsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private lazy var nameCategoryTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Name:"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var nameCategoryLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "_"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var nameLabelsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private lazy var mainLabelsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 20
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        bind()
        setActions()
    }
    
    //MARK: - Private Methods
    private func setActions() {
        categoryView.actionPublisher.sink { [weak self] action in
            guard let self else { return }
            switch action {
            case .titleField(_):
                break
            case .priceField(_):
                break
            case .categoryField(_):
                break
            case .descriptionView(_):
                break
            case .imageOneView(_):
                break
            case .imageTwoView(_):
                break
            case .imageThreeView(_):
                break
            case .searchView(let text):
                Task {
                    await self.findCategoryByName(text)
                }
            }
        }.store(in: &subscriptions)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Delete category"
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(categoryView)
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.hidesBackButton = true
        view.addSubview(buttonsStackView)
        [saveButton, cancelButton].forEach { button in
            button.titleLabel?.font = UIFont.makeTypography(.medium, size: 16)
            buttonsStackView.addArrangedSubview(button)
        }
        
        hideKeyboardWhenTappedAround()
        
        [idCategoryTitle, idCategoryLabel].forEach(idLabelsStackView.addArrangedSubview(_:))
        [nameCategoryTitle, nameCategoryLabel].forEach(nameLabelsStackView.addArrangedSubview(_:))
        
        mainStackView.addArrangedSubview(foundCategoryTitle)
        mainStackView.addArrangedSubview(mainLabelsStackView)
        
        [
            idLabelsStackView,
            nameLabelsStackView,
        ].forEach(mainLabelsStackView.addArrangedSubview(_:))
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 30
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonsStackView.snp.top).offset(-20)
        }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(mainStackView.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        [saveButton, cancelButton].forEach { $0.snp.makeConstraints { $0.height.equalTo(50) } }
        
        foundCategoryTitle.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
        }
        
        mainLabelsStackView.snp.makeConstraints {
            $0.top.equalTo(foundCategoryTitle.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func bind() {
        viewModel.$id.receive(on: DispatchQueue.main).sink { [weak self] id in
            self?.idCategoryLabel.text = id
        }.store(in: &subscriptions)
        
        viewModel.$title.receive(on: DispatchQueue.main).sink { [weak self] name in
            self?.nameCategoryLabel.text = name
        }.store(in: &subscriptions)
    }
    
    private func findCategoryByName(_ name: String) async {
        let result = await NetworkService.shared.fetchAllCategory()
        switch result {
        case .success(let categories):
            let filteredCategories = categories.filter { $0.name?.lowercased().contains(name.lowercased()) ?? false }
            if let firstCategory = filteredCategories.first {
                print("Найдена категория: \(firstCategory.name ?? "No name") с ID: \(firstCategory.id)")
                viewModel.id = "\(firstCategory.id)"
                viewModel.title = firstCategory.name ?? "-"
            } else {
                print("Категория с названием '\(name)' не найдена.")
            }
        case .failure(let error):
            print("Ошибка при запросе категорий: \(error)")
        }
    }
    
    private func deleteCategory() async {
        guard let id = Int(viewModel.id) else { return }
        
        let result = await NetworkService.shared.deleteCategory(id: id)
        switch result {
        case .success():
            print("Category successfully deleted.")
        case .failure(let error):
            print("Error deleting category: \(error)")
        }
    }
}

