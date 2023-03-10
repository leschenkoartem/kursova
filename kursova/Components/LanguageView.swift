//
//  LanguageView.swift
//  kursova
//
//  Created by Artem Leschenko on 10.03.2023.
//

import SwiftUI

struct LanguageView: View {
    var width:CGFloat
    var height:CGFloat
    
    // Step #1
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var showActionSheet = false
    
    var image:Image{
        get{
            switch language {
            case .ukraine:
                return Image("Ukraine")
            case .english_us:
                return Image("England")
            case .spanish:
                return Image("Spain")
            case .deich:
                return Image("Germany")
            case .france:
                return Image("France")
            }
        }
    }
    
    var body: some View {
        
        
        
        VStack(alignment: .leading) {
            
            
            Button {
                showActionSheet.toggle()
            } label: {
                image
                    .resizable()
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
            }

            
            
        }
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("Change language".localized(language)), buttons: [
                            .default(Text("українська")) {
                                // Step #3
                                LocalizationService.shared.language = .ukraine},
                            .default(Text("English (US)")) {  LocalizationService.shared.language = .english_us },
                            .default(Text("Español")) { LocalizationService.shared.language = .spanish },
                            .default(Text("German")) { LocalizationService.shared.language = .deich },
                            .default(Text("French")) { LocalizationService.shared.language = .france },
                            .cancel()
                        ])
                    }
                    
    }
}

struct LanguageView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageView(width: 50.0, height: 50.0)
    }
}
