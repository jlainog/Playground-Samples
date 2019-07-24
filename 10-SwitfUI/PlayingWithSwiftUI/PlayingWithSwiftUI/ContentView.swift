//
//  ContentView.swift
//  PlayingWithSwiftUI
//
//  Created by jaime Laino Guerra on 7/3/19.
//  Copyright © 2019 jaime Laino Guerra. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        VStack {
            Image(systemName: "cloud.heavyrain.fill")
                .font(.largeTitle)
                .aspectRatio(contentMode: .fill)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
