//
//  VerticalStackView.swift
//  PlayingWithSwiftUI
//
//  Created by jaime Laino Guerra on 7/3/19.
//  Copyright © 2019 jaime Laino Guerra. All rights reserved.
//

import SwiftUI

struct VerticalStackView : View {
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: 100, alignment: .center)
            Image(systemName: "cloud.heavyrain.fill")
            Text("Hacking with Swift")
        }
    }
}

#if DEBUG
struct VerticalStackView_Previews : PreviewProvider {
    static var previews: some View {
        VerticalStackView()
    }
}
#endif
