//
//  OrdersViewModel.swift
//  kursova
//
//  Created by Artem Leschenko on 12.04.2023.
//

import Foundation

class DealsViewModel: ObservableObject {
    
    @Published var orders = [Deal]()
    
    
    init(orders: [Deal] = [Deal]()) {
        self.orders = orders
        
    }
    
    func getDeals() {
        Task {
            do {
                orders = try await DBDealsService.shared.getDeals()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

