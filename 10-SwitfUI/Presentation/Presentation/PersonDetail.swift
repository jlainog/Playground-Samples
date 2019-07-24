//
//  PersonDetail.swift
//  SwiftUIPresentation
//
//  Created by Pedro David Ramos Salamanca on 7/22/19.
//  Copyright © 2019 Pedro David Ramos Salamanca. All rights reserved.
//

import SwiftUI

struct PersonDetail : View {
    @State var selectedTags = 0
    
    var person: Person
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                person.iconGender
                VStack (alignment: .leading) {
                    Text(person.name.uppercased())
                        .foregroundColor(person.color)
                        .bold()
                        .font(.title)
                    Text(person.email)
                        .foregroundColor(person.color)
                        .bold()
                        .font(.headline)
                    Text(person.phone)
                        .foregroundColor(person.color)
                        .bold()
                        .font(.subheadline)
                }
            }
            Divider()
            Group {
                Text(person.about)
                    .foregroundColor(person.color)
                    .lineLimit(nil)
                    .padding(4)
                    .blur(radius: 1.5)
                Text("Company: \(person.company)")
                    .foregroundColor(person.color)
                    .bold()
                    .padding(3)
                Text("Age: \(person.age)")
                    .foregroundColor(person.color)
                    .bold()
                    .padding(3)
                Text("Address: \(person.address)")
                    .foregroundColor(person.color)
                    .bold()
                    .lineLimit(nil)
                    .padding(3)
            }
            Form {
                Picker(selection: $selectedTags,
                       label: Text("TAGS").foregroundColor(person.color)) {
                    ForEach(0 ..< person.tags.count) {
                        Text(self.person.tags[$0])
                            .foregroundColor(self.person.color)
                            .bold()
                            .tag($0)
                    }
                }
            }.font(.headline)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .border(person.color, width: 2, cornerRadius: 15)
            .padding(5)
    }
}

#if DEBUG
struct PersonDetail_Previews : PreviewProvider {
    static var previews: some View {
        PersonDetail(person: personsData[0])
    }
}
#endif
