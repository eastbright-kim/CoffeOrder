//
//  OrderViewModel.swift
//  HotCoffe
//
//  Created by 김동환 on 2021/02/04.
//

import Foundation

class OrderListViewModel {
    var ordersListViewModel: [OrderViewModel]
    
    init() {
        self.ordersListViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    func orderViewModel(at index: Int)->OrderViewModel{
        return self.ordersListViewModel[index]
    }
}


struct OrderViewModel {
    let order: Order
}

extension OrderViewModel {
    
    var name: String {
        return order.name
    }
    
    var email: String {
        return order.email
    }
    
    var coffeeType: String {
        return order.type.rawValue.capitalized
    }
    
    var coffeeSize: String {
        return order.size.rawValue.capitalized
    }
}
