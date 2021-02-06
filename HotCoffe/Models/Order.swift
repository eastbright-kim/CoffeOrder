//
//  Order.swift
//  HotCoffe
//
//  Created by 김동환 on 2021/02/03.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espressino
    case cortado
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}

extension Order {
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("error in fetching url")
        }
        
        let resource = Resource<[Order]>(url: url)
    
       return resource
    }()
    
    static func create(_ vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        
        let order = Order(vm)
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("error in fetching url")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("error in encoding")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethod.post
        resource.body = data
        
        return resource
    }
}

extension Order {
    
    init?(_ vm: AddCoffeeOrderViewModel){
        
        guard let name = vm.name,
              let email = vm.email,
              let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
              let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else{
            return nil
        }

        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
    
}
