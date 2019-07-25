//
//  Person.swift
//  SwiftUIPresentation
//
//  Created by Pedro David Ramos Salamanca on 7/22/19.
//  Copyright © 2019 Pedro David Ramos Salamanca. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Person: Hashable, Codable, Identifiable {
    var id: Int
    var isActive: Bool
    var age: Int
    fileprivate var eyeColor: EyeColor
    var name: String
    fileprivate var gender: Gender
    var company: String
    var email: String
    var phone: String
    var address: String
    var about: String
    var registered: String
    var tags: [String]
    
    var iconGender: ImageGender {
        var image: Image
        switch self.gender {
        case .male:
            image = Image("swordman")
        case .female:
            image = Image("swordwoman")
        }
        
        return ImageGender(image: image, color: color)
        
    }
    
    var color: Color {
        switch self.eyeColor {
        case .blue:
            return Color("eyeBlue")
        case .brown:
            return Color("eyeBrown")
        case .green:
            return Color("eyeGreen")
        }
    }
    
    var iconId: Image {
        return Image(systemName: "\(self.id).circle")
    }
}

enum Gender: String, CaseIterable, Codable, Hashable {
    case male = "male"
    case female = "female"
}

enum EyeColor: String, CaseIterable, Codable, Hashable {
    case blue = "blue"
    case brown = "brown"
    case green = "green"
}

struct ImageGender: View {
    var image: Image
    var color: Color

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(1)
            .colorMultiply(color)
            .frame(width: 50, height: 50, alignment: .topLeading)
            .padding(5)
    }
}
