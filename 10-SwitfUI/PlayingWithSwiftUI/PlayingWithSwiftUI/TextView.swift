//
//  TextView.swift
//  PlayingWithSwiftUI
//
//  Created by jaime Laino Guerra on 7/3/19.
//  Copyright © 2019 jaime Laino Guerra. All rights reserved.
//

import SwiftUI

struct TextView : View {
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    var dueDate = Date()
    
    var body: some View {
        VStack {
            Text("Task due date: \(dueDate, formatter: Self.taskDateFormat)")
            Text("This is an extremely long string that will never fit even the widest of Phones")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .lineLimit(0)
                .background(Color.yellow)
                .foregroundColor(Color.red)
                .lineSpacing(50)
            Text("Hello World") .padding()
                .foregroundColor(.white)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .red, .black]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing),
                    cornerRadius: 50)
            Text("Background Image")
                .font(.largeTitle)
                .background(
                    Image(systemName: "cloud.heavyrain.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.red)
                        .clipped())
        }
    }
}

#if DEBUG
struct TextView_Previews : PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
#endif
