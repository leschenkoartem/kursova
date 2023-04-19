//
//  Swd.swift
//  TA
//
//  Created by Artem Leschenko on 17.04.2023.
//

import SwiftUI

struct Swd: View {
    @State var days = ["Ponedel","Vtor","Sreda","Chetv","Pyatniza","Subota","Voskrese"]
    @State var pickedDay = ""
    @State var wdt: CGFloat = 100
    @State var hgt: CGFloat = 100
    var body: some View {
        
        
        VStack {
            Rectangle().frame(width: wdt, height: hgt)
            Slider(value: $wdt, in: 0...400, step: 1)
            Slider(value: $hgt, in: 0...400, step: 1)
        }
//        HStack {
//            ForEach(days, id: \.self) { day in
//                ZStack {
//                    Circle()
//                        .frame(width: 40)
//                        .foregroundColor( pickedDay.contains(day)  ? .red : .blue)
//                        .animation(.easeInOut(duration: 0.3), value: pickedDay.contains(day))
//                    Text(day.prefix(2))
//                }.onTapGesture {
//                    pickedDay = pickedDay == day ? "" : day
//                }
//            }
//        }
    }
}

struct Swd_Previews: PreviewProvider {
    static var previews: some View {
        Swd()
    }
}
