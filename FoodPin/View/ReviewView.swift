//
//  ReviewView.swift
//  FoodPin
//
//  Created by 方曦 on 2023/7/29.
//

import SwiftUI

struct ReviewView: View {

    /**
     页面是否关闭状态
     */
    @Binding var isDisplayed: Bool
    var restaurant: Restaurant
    /**
     控制起始状态与终止状态，false表示起始状态
     */
    @State private var showRatings = false
    
    var body: some View {
        ZStack {
            // 背景图
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea()
            
            // 黑色蒙版
            Color.black
                .opacity(0.6)
                // 模糊效果
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            HStack {
                Spacer()
                
                VStack {
                    Button {
                        // 淡出动画
                        withAnimation(.easeOut(duration: 0.3)) {
                            self.isDisplayed = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 30.0))
                            .foregroundColor(.white)
                            .padding()
                    }

                    Spacer()
                }
            }
            
            VStack(alignment: .leading) {
                ForEach(Restaurant.Rating.allCases, id: \.self) { rating in
                    HStack {
                        Image(rating.image)
                        Text(rating.rawValue.capitalized)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .opacity(showRatings ? 1.0 : 0)
                    // 将评分按钮移出屏幕, 向右移动1000
                    .offset(x: showRatings ? 0 : 1000)
                    .animation(.easeIn.delay(Double(Restaurant.Rating.allCases.firstIndex(of: rating)!) * 0.05), value: showRatings)
                }
            }
        }
        .onAppear() {
            showRatings.toggle()
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(isDisplayed: .constant(true), restaurant: Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", description: "Searching for great breakfast eateries and coffee? This place is for you. We open at 6:30 every morning, and close at 9 PM. We offer espresso and espresso based drink, such as capuccino, cafe latte, piccolo and many more. Come over and enjoy a great meal.", image: "cafedeadend", isFavorite: true))
    }
}
