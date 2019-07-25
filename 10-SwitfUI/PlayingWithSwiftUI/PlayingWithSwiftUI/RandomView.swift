//
//  RandomView.swift
//  PlayingWithSwiftUI
//
//  Created by jaime Laino Guerra on 7/3/19.
//  Copyright © 2019 jaime Laino Guerra. All rights reserved.
//

import SwiftUI

struct RandomView : View {
    var body: some View {
        Group {
            if Bool.random() {
                Image("example-image")
            } else {
                Text("Better luck next time")
            }
        }
    }
}

#if DEBUG
struct RandomView_Previews : PreviewProvider {
    static var previews: some View {
        RandomView()
    }
}
#endif
