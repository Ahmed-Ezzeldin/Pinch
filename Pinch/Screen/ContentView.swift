//
//  ContentView.swift
//  Pinch
//
//  Created by Codemaker on 29/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Property ========================================
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDraerOpen: Bool = false
    
    
    // MARK: Function ========================================
    func resetImageState(){
        return withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
        
    }
    
    // MARK: Content ========================================
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.clear
                // MARK: Page Image
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black, radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .offset(x: imageOffset.width , y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }else{
                            resetImageState()
                        }
                    })
                    .gesture(
                        DragGesture()
                            .onChanged{value in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded{_ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                   withAnimation(.linear(duration: 1)){
                                       if imageScale >= 1 && imageScale <= 5 {
                                           imageScale = value
                                       } else if imageScale > 5{
                                           imageScale = 5
                                       }
                                   }
                               }
                               .onEnded { _ in
                                   if imageScale > 5 {
                                       imageScale = 5
                                   } else if imageScale <= 1 {
                                       resetImageState()
                                   }
                               }
                    )
            } //: ZStack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform:                 {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            })
            // MARK: Info Panel
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            // MARK: Control
            .overlay(
                Group{
                    HStack{
                        Button{
                            if imageScale > 1 {
                                imageScale -= 1
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                            
                        } label: {
                            ControlImageView(icon:  "minus.magnifyingglass")
                        }
                        Button{
                            resetImageState()
                            
                        } label: {
                            ControlImageView(icon:  "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        Button{
                            if imageScale < 5 {
                                imageScale += 1
                                if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                            
                        } label: {
                            ControlImageView(icon:  "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .opacity(isAnimating ? 1 : 0)
                    
                }
                    .padding(.bottom , 20)
                , alignment: .bottom
            )
            // MARK: Drawer =================================
            .overlay(
                HStack(spacing: 12){
                    
                    // Drawer Handle
                    Image(systemName: isDraerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame( height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut(duration: 1)){
                                isDraerOpen.toggle()
                            }
                        })
                    // Thumnales
                    Spacer()
                    
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ?  1 : 0)
                    .offset(x: isDraerOpen ? 20 : 215)
                    .frame(width: 260)
                    .padding(.top , UIScreen.main.bounds.height / 12)
                , alignment: .topTrailing
            )
        } //: NavigationView
        .navigationViewStyle(.stack)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
