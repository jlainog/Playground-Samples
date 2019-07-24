//
//  ContentView.swift
//  SwiftUIPresentation
//
//  Created by Pedro David Ramos Salamanca on 7/22/19.
//  Copyright © 2019 Pedro David Ramos Salamanca. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentView : View {
    private var colorScheme: ColorScheme {
        isDark ? .dark : .light
    }
    
    @State private var quantity: Length = 2
    @State private var isDark = false
    var formattedQuantity: String { "\(quantity)" }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .trailing) {
                
                Stepper(value: $quantity, in: 1...7, label: {
                    Text("Quantity \(formattedQuantity)")
                        .bold()
                }).padding(3).padding(.horizontal, 25)
                
                Divider()
                
                Toggle(isOn: $isDark) {
                    Text("Change Scheme Color")
                        .bold()
                }.padding(3).padding(.horizontal, 25)
                
                Divider()
                
                List(personsData) { person in
                    NavigationLink(destination: PersonDetail(person: person),
                                   label: { PersonDetail(person: person) })
                        .padding(8)
                        .border(person.color,
                                width: self.quantity,
                                cornerRadius: 8)
                }
            }.navigationBarTitle(Text("List"))
        }.colorScheme(colorScheme)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
