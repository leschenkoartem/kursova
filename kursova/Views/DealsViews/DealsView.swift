//
//  DealsView.swift
//  kursova
//
//  Created by Artem Leschenko on 12.04.2023.
//

import SwiftUI

struct DealsView: View {
    @EnvironmentObject var dealsView: DealsViewModel
    
    
    var body: some View {
        ScrollView {
            ForEach(dealsView.orders, id: \.id) { deal in
                DetailInfoView(deal: deal)
            }
            Spacer().frame(height: 130)
        }.onAppear {
            dealsView.getDeals()
        }
    }
}

struct DealsView_Previews: PreviewProvider {
    static var previews: some View {
        DealsView().environmentObject(DealsViewModel())
    }
}
