//
//  DetailInfoView.swift
//  kursova
//
//  Created by Artem Leschenko on 12.04.2023.
//

import SwiftUI

struct DetailInfoView: View {
    
    var deal: Deal
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(deal.name)
                .font(.title3)
                .bold()
            Text("\nОб'єкт був проданий:").bold() + Text("\n\(deal.salesman) -> \(deal.buyer)")
            Text("\nЦіна: ").bold() + Text("\(deal.price)$")
            Text("Час: ").bold() + Text("\(dateFormatter.string(from: deal.time))")
            Text("Ідентифікатор угоди:\n").bold() + Text("\(deal.id)").font(.footnote)
        }.frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
            .background(Color(.systemGray6).opacity(0.75))
            .padding(.horizontal, 5)
            .cornerRadius(30)
            .shadow(radius: 5)
            .foregroundColor(Color(.label).opacity(0.75))
    }
}

struct DetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DetailInfoView(deal: Deal(buyer: "artemleschenko296@gmail.com", salesman: "leschenkoapp@gmail.com", time: Date(), price: 12500, name: "Rolc Roys"))
    }
}
