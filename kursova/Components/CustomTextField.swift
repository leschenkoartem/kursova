//
//  CustomTextFild.swift
//  kursova
//
//  Created by Artem Leschenko on 01.03.2023.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text:String
    var titleOfField:String
    var placeholder:String
    let maxLettes:Int
    
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text(titleOfField).font(.headline).fontWeight(.light).foregroundColor(Color(.label).opacity(0.75))
            
            HStack{
                TextField(placeholder, text: $text).autocorrectionDisabled(true).textInputAutocapitalization(.never)
                    .onChange(of: text) { newText in
                    if newText.count > maxLettes { // Limit input to 180 characters
                        text = String(newText.prefix(maxLettes))
                    }
                }
            }
            
            Divider()
        }
    }
}
struct CustomTextField_Previews: PreviewProvider {
    @State static var a = ""
    static var previews: some View {
        CustomTextField(text: $a, titleOfField: "cd", placeholder: "wdx", maxLettes: 10)
    }
}
