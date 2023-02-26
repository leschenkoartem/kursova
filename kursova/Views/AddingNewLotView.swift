//
//  AddingNewLotView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 23.02.2023.
//

import SwiftUI

struct AddingNewLotView: View {
    
    
    @State var mainText:String = ""
    @State var currentPrice:String = ""
    
    @State var informationText:String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Text("return")
            }
        
        TextField("Main text", text: $mainText)
        TextField("Main text", text: $currentPrice).keyboardType(.numberPad)
        TextField("Main text", text: $informationText)
        Button {
            DatabaseService.shared.addLotToFirestore(lot: Lot_str(idCreator: AuthService.shared.currentUser!.uid, idCurrentPerson: "", mainText: mainText, currentPrice: Int(currentPrice)!, informationText: informationText))
        }label: {
            Text("register")
            }

    }
}

struct AddingNewLotView_Previews: PreviewProvider {
    static var previews: some View {
        AddingNewLotView()
    }
}
