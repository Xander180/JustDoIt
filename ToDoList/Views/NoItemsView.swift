//
//  NoItemsView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 6/4/24.
//

import SwiftUI

struct NoItemsView: View {
    @State var animate = false
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Nothing to do (yet)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                
                
                NavigationLink("Add Something") {
                    AddItemView()
                }
                .foregroundStyle(Color.white)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(animate ? secondaryAccentColor : Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, animate ? 30 : 50)
//                .shadow(color: animate ? secondaryAccentColor.opacity(0.7) : Color.accentColor.opacity(0.7),
//                        radius: animate ? 30 : 10,
//                        x: 0.0,
//                        y: animate ? 50 : 30)
                .scaleEffect(animate ? 1.1 : 1.0)
                //.offset(y: animate ? -7 : 0)
            }
            .multilineTextAlignment(.center)
            .padding(40)
            .onAppear(perform: addAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func addAnimation() {
        guard !animate else { return }
            withAnimation(
                Animation
                    .easeInOut(duration: 1.5)
                    .repeatForever()
            ) {
                animate.toggle()
            }
    }
}

#Preview {
    NavigationStack {
        NoItemsView()
    }
    .navigationTitle("Title")
}
