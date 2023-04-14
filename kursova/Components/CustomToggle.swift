//
//  CustomToggle.swift
//  kursova
//
//  Created by Artem Leschenko on 18.03.2023.
//

import SwiftUI

struct CustomToggle: View {
    @Binding var switchMark: Bool
    
    var body: some View{
        HStack{
            Toggle(isOn: $switchMark) {
                Image(systemName: switchMark ? "checkmark": "xmark")
            }.toggleStyle(.button)
                .frame(width: 33, height: 30)
                .background(switchMark
                            ? Color.green.opacity(0.4)
                            : Color.red.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(5)
                .animation(.easeInOut(duration: 0.3), value: switchMark)
        }.frame(maxWidth: 40)
    }
}

struct CustomToggle_Previews: PreviewProvider {
    static var previews: some View {
        CustomToggle(switchMark: .constant(true))
    }
}
