//
//  ViewController.swift
//  TodoList
//
//  Created by Rafaell Andrade on 18/06/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        title = "Todo List 🔥"
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter your todo item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { field in
            field.placeholder = "Enter item..."
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    func didTapEdit(selectedRowIndex: Int) {
        let ac = UIAlertController(title: "Edit Todo", message: "Enter the new todo", preferredStyle: .alert)
        ac.addTextField(configurationHandler: { [weak self] field in
            field.text = self?.items[selectedRowIndex]
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] (_) in
            if let field = ac.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        var currentItens = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        if !currentItens.isEmpty {
                            currentItens[selectedRowIndex] = text
                            UserDefaults.standard.setValue(currentItens, forKey: "items")
                            self?.items[selectedRowIndex] = text
                            self?.table.reloadData()
                        }
                    }
                }
            }
        }))
        present(ac, animated: true)
    }
    
    func didTapDelete(selectedRowIndex: Int) {
        DispatchQueue.main.async { [weak self] in
            var currentItens = UserDefaults.standard.stringArray(forKey: "items") ?? []
            if !currentItens.isEmpty {
                currentItens.remove(at: selectedRowIndex)
                UserDefaults.standard.setValue(currentItens, forKey: "items")
                self?.items.remove(at: selectedRowIndex)
                self?.table.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTapEdit(selectedRowIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            didTapDelete(selectedRowIndex: indexPath.row)
        }
    }
}

