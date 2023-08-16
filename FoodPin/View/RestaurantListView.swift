//
//  RestaurantListView.swift
//  FoodPin
//
//  Created by Simon Ng on 14/10/2022.
//

import SwiftUI

struct RestaurantListView: View {
    
    @FetchRequest(
        entity: Restaurant.entity(),
        sortDescriptors: [])
    var restaurants: FetchedResults<Restaurant>
    
    @Environment(\.managedObjectContext) var context
    
    @State private var showNewRestaurant = false
    @State private var keywords = ""
    @State private var showWalkthrough = false
    @AppStorage("hasViewedWalkthrough") private var hasViewedWalkthrough: Bool = false
    
    var body: some View {
        NavigationStack {
            
            List {
                if restaurants.count == 0 {
                    Image("emptyData")
                        .resizable()
                        .scaledToFit()
                } else {
                    ForEach(restaurants.indices, id: \.self) { index in
                        // 通过ZStack取消右箭头
                        ZStack(alignment: .leading, content: {
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurants[index])) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            BasicTextImageRow(restaurant: restaurants[index])
                                .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                                    Button {
                                        restaurants[index].isFavorite.toggle()
                                    } label: {
                                        Image(systemName: "heart")
                                    }
                                    .tint(.green)
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                    .tint(.orange)
                                })
                        })
                        
                    }
                    .onDelete(perform: deleteRecord)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            // 导览视图
            .navigationTitle("FoodPin")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                Button {
                    self.showNewRestaurant = true
                } label: {
                    Image(systemName: "plus")
                }

            }
            
        }
        // placement: .navigationBarDrawer(displayMode: .always) 固定搜索列，可以去除，默认.automaic
        .searchable(text: $keywords, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Restaurant...")
        // 坐上返回按钮默认蓝色
        .accentColor(.primary)
        .sheet(isPresented: $showNewRestaurant) {
            NewRestaurantView()
        }
        .sheet(isPresented: $showWalkthrough) {
            TutorialView()
        }
        .onChange(of: keywords) { keywords in
            let predicate =  keywords.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[c] %@", keywords)
            restaurants.nsPredicate = predicate
        }
        .onAppear() {
            showWalkthrough = !hasViewedWalkthrough
        }
        
    }
    
    private func deleteRecord(intdexSet: IndexSet) {
        for index in intdexSet {
            let itemOnDelete = restaurants[index]
            context.delete(itemOnDelete)
        }
        
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

struct BasicTextImageRow: View {
    
    // MARK: - Binding
    
    @ObservedObject var restaurant: Restaurant
    
    // MARK: - State variables
    
    @State private var showOptions = false
    @State private var showError = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(uiImage: UIImage(data: restaurant.image) ?? UIImage())
                .resizable()
                .frame(width: 120, height: 118)
                .cornerRadius(20)
            
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.system(.title2, design: .rounded))
                
                Text(restaurant.type)
                    .font(.system(.body, design: .rounded))
                
                Text(restaurant.location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            if restaurant.isFavorite {
                Spacer()
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.yellow)
            }
        }
        .contextMenu {
            
            Button(action: {
                self.showError.toggle()
            }) {
                HStack {
                    Text("Reserve a table")
                    Image(systemName: "phone")
                }
            }
            
            Button(action: {
                self.restaurant.isFavorite.toggle()
            }) {
                HStack {
                    Text(restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite")
                    Image(systemName: "heart")
                }
            }
            
            Button(action: {
                self.showOptions.toggle()
            }) {
                HStack {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .alert("Not yet available", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text("Sorry, this feature is not available yet. Please retry later.")
        }
        .sheet(isPresented: $showOptions) {
            
            let defaultText = "Just checking in at \(restaurant.name)"
            
            if let imageToShare = UIImage(data: restaurant.image) {
                ActivityView(activityItems: [defaultText, imageToShare])
            } else {
                ActivityView(activityItems: [defaultText])
            }
        }
    }
    

}


struct FullImageRow: View {
    
    var imageName: String
    var name: String
    var type: String
    var location: String
    
    @Binding var isFavorite: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(20)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(.title2, design: .rounded))
                        
                    Text(type)
                        .font(.system(.body, design: .rounded))
                    
                    Text(location)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                if isFavorite {
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.yellow)
                }

            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
        
        BasicTextImageRow(restaurant: (PersistenceController.testData?.first)!)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("BasicTextImageRow")
                
        FullImageRow(imageName: "cafedeadend", name: "Cafe Deadend", type: "Cafe", location: "Hong Kong", isFavorite: .constant(true))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FullImageRow")
    }
}
