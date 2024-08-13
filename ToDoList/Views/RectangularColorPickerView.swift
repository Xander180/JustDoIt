//
//  RectangularColorPickerView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 8/5/24.
//

import SwiftUI

struct RectangularColorPickerView: View {
    @Binding var colorValue: Color
    
    var body: some View {
        colorValue
            .frame(width: 200, height: 50, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, style: StrokeStyle(lineWidth: 5)))
            .padding(10)
            .background(AngularGradient.init(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .pink]), center: .center).clipShape(RoundedRectangle(cornerRadius: 20)))
            .overlay(ColorPicker("", selection: $colorValue, supportsOpacity: false).labelsHidden().opacity(0.015).scaleEffect(CGSize(width: 7.5, height: 5.0)))
            .background(Color.black.opacity(0.001))
    }
}

#Preview {
    struct Preview: View {
        @State var colorValue = Color.blue
        var body: some View {
            RectangularColorPickerView(colorValue: $colorValue)
        }
    }
    
    return Preview()
}
