//
//  DetailInfoView.swift
//  kursova
//
//  Created by Artem Leschenko on 12.04.2023.
//

import SwiftUI

struct DealsInfoView: View {
    
    //Для мови
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
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
            Text("\nObject was sold:".localized(language)).bold() + Text("\n\(deal.salesman) -> \(deal.buyer)")
            Text("\nPrice: ".localized(language)).bold() + Text("\(deal.price)$")
            Text("Time: ".localized(language)).bold() + Text("\(dateFormatter.string(from: deal.time))")
            Text("Deal ID:\n".localized(language)).bold() + Text("\(deal.id)").font(.footnote)
        }.frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
            .background(Color(.systemGray6).opacity(0.75))
            .padding(.horizontal, 5)
            .cornerRadius(30)
            .shadow(radius: 5)
            .foregroundColor(Color(.label).opacity(0.75))
            .contextMenu {
                Button {
                    UIPasteboard.general.string = deal.id
                } label: {
                    Text("Copy ID".localized(language))
                    Image(systemName: "doc.on.doc.fill")
                        .foregroundColor(Color(.label))
                }
            }
    }
}

struct DetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DealsInfoView(deal: Deal(buyer: "artemleschenko296@gmail.com", salesman: "leschenkoapp@gmail.com", time: Date(), price: 12500, name: "Rolc Roys"))
    }
}
