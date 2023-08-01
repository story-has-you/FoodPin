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
    @Environment(\.managedObjectContext) var context
    @ObservedObject var restaurant: Restaurant
    @State private var showReview = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 背景图片
                Image(uiImage: UIImage(data: restaurant.image)!)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 445)
                    .overlay {
                        // 上面的爱心
                        VStack {
                            Image(systemName: restaurant.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(restaurant.isFavorite ? .yellow : .white)
                                .frame(minWidth: 0, maxWidth: .infinity,
                                       minHeight: 0, maxHeight: .infinity,
                                       alignment: .topTrailing)
                                .padding()
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding(.top, 40)

                    
                            // 加入餐厅和类型名称
                            HStack(alignment: .bottom) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(restaurant.name)
                                        .font(.custom("Nunito-Regular", size: 35, relativeTo: .largeTitle))
                                        .bold()
                                    Text(restaurant.type)
                                        .font(.system(.headline, design: .rounded))
                                        .padding(.all, 5)
                                        .background(.black)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity,
                                       minHeight: 0, maxHeight: .infinity,
                                       alignment: .bottomLeading)
                                .foregroundColor(.white)
                                .padding()
                                
                                if let rating = restaurant.rating, !showReview {
                                    Image(rating.image)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .padding([.bottom, .trailing])
                                        .transition(.scale)
                                }
                            }
                            .animation(.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.3), value: restaurant.rating)
                        }
                    }
                
                // 加入餐厅介绍
                Text(restaurant.summary)
                    .padding()
                
                // 地址和电话
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("ADDRESS")
                            .font(.system(.headline, design: .rounded))
                        
                        Text(restaurant.location)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("PHONE")
                            .font(.system(.headline, design: .rounded))
                        Text(restaurant.phone)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                // 地图显示
                NavigationLink {
                    MapView(location: restaurant.location)
                        .edgesIgnoringSafeArea(.all)
                } label: {
                    MapView(location: restaurant.location)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(20)
                        .padding()
                }
             
                // 加入评分按钮
                Button {
                    self.showReview.toggle()
                } label: {
                    Text("Rate it")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .tint(Color("NavigationBarTitle"))
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 25))
                .controlSize(.large)
                .padding(.horizontal)
                .padding(.bottom, 20)

            }
        }
        .onChange(of: restaurant, perform: { _ in
            if self.context.hasChanges {
                try? self.context.save()
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
        .ignoresSafeArea()
        .overlay {
            self.showReview ? ZStack {
                ReviewView(isDisplayed: $showReview ,restaurant: restaurant)
                    .navigationBarHidden(true)
            } : nil
        }
        
        
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RestaurantDetailView(restaurant: (PersistenceController.testData?.first)!)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
        .accentColor(.white)
    }
}
