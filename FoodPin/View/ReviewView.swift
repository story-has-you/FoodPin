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
            Image(uiImage: UIImage(data: restaurant.image)!)
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
                    // 移入动画效果
                    .animation(.easeIn.delay(Double(Restaurant.Rating.allCases.firstIndex(of: rating)!) * 0.1), value: showRatings)
                    .onTapGesture {
                        self.restaurant.rating = rating
                        self.isDisplayed = false
                    }
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
        ReviewView(isDisplayed: .constant(true), restaurant: (PersistenceController.testData?.first)!)
    }
}
