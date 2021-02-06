//
//  AddOrderViewController.swift
//  HotCoffe
//
//  Created by 김동환 on 2021/02/03.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var delegate: AddCoffeeOrderDelegate?
    private var vm = AddCoffeeOrderViewModel()
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        setupUI()
    }
    
    func setupUI(){
        
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: vm.sizes)
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(coffeeSizesSegmentedControl)
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.types[indexPath.row]
        
        return cell
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        self.vm.name = nameTextField.text
        self.vm.email = emailTextField.text
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("error in selecting coffee")
        }
        
        self.vm.selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
        
        self.vm.selectedType = self.vm.types[indexPath.row]

        Webservice().load(resource: Order.create(self.vm)) { result in
            
            switch result {
            case .success(let orders):
                guard let delegate = self.delegate, let order = orders else{
                    fatalError("delegate error")
                }
                DispatchQueue.main.async {
                    delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func close() {
        guard let delegate = self.delegate else {
            fatalError("error in closing")
        }
        delegate.addCoffeeOrderViewControllerDidClose(controller: self)
    }
}
