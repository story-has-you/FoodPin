//
//  RestaurantDetailView.swift
//  FoodPin
//
//  Created by 方曦 on 2023/7/20.
//

import SwiftUI

struct RestaurantDetailView: View {
    
    var restaurant: Restaurant
    
    var body: some View {
        ZStack(alignment: .top, content: {
            // 背景图片
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                // frame 设置宽高 infinity 占满屏幕
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea()
            
            Color.black
                .frame(height: 100)
                .opacity(0.8)
                .cornerRadius(20)
                .padding()
                // overlay 覆盖Color的内容
                .overlay {
                    VStack(spacing: 5, content: {
                        Text(restaurant.name)
                        Text(restaurant.type)
                        Text(restaurant.location)
                    })
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.white)
                }
        })
        
        
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(restaurant: Restaurant(name: "Cafe Deadend", type: "Cafe", location: "Hong Kong", image: "cafedeadend", isFavorite: true))
    }
}
