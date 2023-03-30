//
//  TabBar.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 22.02.2023.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case hammer
    case house
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    var tabColor = Color(.label).opacity(0.7)
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                        .foregroundColor(tab == selectedTab ? tabColor : .gray)
                        .font(.system(size: 20))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding()
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.house))
    }
}



