//
//  ShapesView.swift
//  PlayingWithSwiftUI
//
//  Created by jaime Laino Guerra on 7/3/19.
//  Copyright © 2019 jaime Laino Guerra. All rights reserved.
//

import SwiftUI

struct ShapesView : View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
            Rectangle()
                .fill(Color.red)
                .frame(width: 200, height: 200)
        }
    }
}

#if DEBUG
struct SwiftUIView_Previews : PreviewProvider {
    static var previews: some View {
        ShapesView()
    }
}
#endif
