//
//  CustomTextFild.swift
//  kursova
//
//  Created by Artem Leschenko on 01.03.2023.
//

import SwiftUI

struct CustomTextFild: View {
    
    @Binding var text:String
    var titlet:String
    var texft:String
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text(titlet).font(.headline).fontWeight(.light).foregroundColor(Color(.label).opacity(0.75))
            
            HStack{
                TextField(texft, text: $text).autocorrectionDisabled(true).textInputAutocapitalization(.never)
            }
            
            Divider()
        }
    }
}
struct CustomTextFild_Previews: PreviewProvider {
    @State static var a = ""
    static var previews: some View {
        CustomTextFild(text: $a, titlet: "cd", texft: "wdx")
    }
}
