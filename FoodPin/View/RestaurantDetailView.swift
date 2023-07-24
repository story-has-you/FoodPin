//
//  RestaurantDetailView.swift
//  FoodPin
//
//  Created by 方曦 on 2023/7/20.
//

import SwiftUI

struct RestaurantDetailView: View {
    
    
    // 关闭目前视图
    @Environment(\.dismiss) var dismiss
    
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
                    // .font(.system(.headline, design: .rounded))
                    .font(.custom("Nunito-Regular", size: 17))
                    .foregroundColor(.white)
                }
        })
        // 隐藏原先的返回按钮
        .navigationBarBackButtonHidden(true)
        // 建立自己的返回按钮
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("\(Image(systemName: "chevron.left")) \(restaurant.name)")
                })
            })
        }
        
        
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RestaurantDetailView(restaurant: Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", description: "Searching for great breakfast eateries and coffee? This place is for you. We open at 6:30 every morning, and close at 9 PM. We offer espresso and espresso based drink, such as capuccino, cafe latte, piccolo and many more. Come over and enjoy a great meal.", image: "cafedeadend", isFavorite: true))
        }
        .accentColor(.white)
    }
}
