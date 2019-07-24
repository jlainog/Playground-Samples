//
//  PersonRow.swift
//  SwiftUIPresentation
//
//  Created by Pedro David Ramos Salamanca on 7/22/19.
//  Copyright © 2019 Pedro David Ramos Salamanca. All rights reserved.
//

import SwiftUI

struct PersonRow : View {
    var person: Person
    var body: some View {
        HStack {
            person.iconId
                .foregroundColor(person.color)
                .font(.system(size: 15))
            Text(person.name)
                .foregroundColor(person.color)
                .font(.system(size: 15))
                .bold()
            Spacer()
        }
    }
}

#if DEBUG
struct PersonRow_Previews : PreviewProvider {
    static var previews: some View {
        PersonRow(person: personsData[0])
    }
}
#endif
