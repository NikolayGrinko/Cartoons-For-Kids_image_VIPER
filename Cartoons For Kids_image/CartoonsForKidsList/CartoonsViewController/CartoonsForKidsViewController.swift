//
//  CartoonsForKidsViewController.swift
//  Cartoons For Kids_image
//
//  Created by Николай Гринько on 27.08.2024.
//

import UIKit

protocol ICartoonsListViewProtocol {
	
	var presenter: ICartoonsListPresenterProtocol? {get set}
	
	func update(with cartoons: [CartoonModelEntity])
	func update(with error:String)
}

class CartoonsForKidsViewController: UIViewController, ICartoonsListViewProtocol {
	
	// MARK: - COMPONENT
	private let tableView: UITableView = UITableView()
	private let messageLabel: UILabel = UILabel()
	
	// MARK: - PROPERTY
	var presenter: ICartoonsListPresenterProtocol?
	var cartoons: [CartoonModelEntity] = []
	
	// MARK: - LIFE CYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "CartoonsForKids"
		style()
		layout()
		presenter?.viewGetData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if let seledtIndex = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: seledtIndex, animated: true)
		}
	}
}

extension CartoonsForKidsViewController {
	func style() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.isHidden = true
		tableView.delegate = self
		tableView.dataSource = self
		
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.isHidden = false
		messageLabel.text = "Loading..."
		messageLabel.font = UIFont.systemFont(ofSize: 20)
		messageLabel.textColor = .black
		messageLabel.textAlignment = .center
	}
	
	func layout() {
		view.addSubview(tableView)
		view.addSubview(messageLabel)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		
		
		NSLayoutConstraint.activate([
			messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
		
	}
}

// MARK: - CartoonsList_View_Protocol
extension CartoonsForKidsViewController {
	func update(with cartoons: [CartoonModelEntity]) {
		DispatchQueue.main.async { [weak self] in
			self?.cartoons = cartoons
			self?.messageLabel.isHidden = true
			self?.tableView.reloadData()
			self?.tableView.isHidden = false
		}
	}
	
	func update(with error: String) {
		
		DispatchQueue.main.async { [weak self] in
			self?.cartoons = []
			self?.tableView.isHidden = true
			
			self?.messageLabel.isHidden = false
			self?.messageLabel.text = error
		}
	}
}

// MARK: - UITableViewDelegate
extension CartoonsForKidsViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.tapOnDetail(cartoons[indexPath.row])
		
	}
}

// MARK: - UITableViewDataSource
extension CartoonsForKidsViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cartoons.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
		var content = cell.defaultContentConfiguration()
		content.text = cartoons[indexPath.row].title
		content.secondaryText = "\(cartoons[indexPath.row].year)"
		cell.contentConfiguration = content
		return cell
	}
}

// MARK: - Unit Testing
extension CartoonsForKidsViewController {
	func errorMessageForTesting() -> String? {
		return messageLabel.text
	}
	
	func errorLabelIsHiddenForTest() -> Bool {
		return messageLabel.isHidden
	}
}
