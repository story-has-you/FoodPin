//
//  NewRestaurantView.swift
//  FoodPin
//
//  Created by 方曦 on 2023/7/31.
//

import SwiftUI

struct NewRestaurantView: View {
    
    @State var restaurantName = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    FormTextField(label: "NAME", placeholder: "Fill in the restaurant name", value: .constant(""))
                                        
                    FormTextField(label: "TYPE", placeholder: "Fill in the restaurant type", value: .constant(""))
                    
                    FormTextField(label: "ADDRESS", placeholder: "Fill in the restaurant address", value: .constant(""))
                    
                    FormTextField(label: "PHONE", placeholder: "Fill in the restaurant phone", value: .constant(""))
                    
                    FormTextView(label: "DESCRIPTION", value: .constant(""), height: 100)
                }
                .padding()
            }
        }
    }
        
}

struct NewRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NewRestaurantView()
        
        FormTextField(label: "NAME", placeholder: "Fill in the restaurant name", value: .constant(""))
                    .previewLayout(.fixed(width: 300, height: 200))
                    .previewDisplayName("FormTextField")
                
        FormTextView(label: "Description", value: .constant(""))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FormTextView")
    }
}


struct FormTextField: View {
    /**
     显示在文字上方的标记
     */
    let label: String
    /**
     文字栏位初始值
     */
    var placeholder: String = ""
    /**
     绑定到的栏位值
     */
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            
            TextField(placeholder, text: $value)
                .font(.system(.body, design: .rounded))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .overlay (
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.vertical, 10)
        }
    }
}

struct FormTextView: View {
    let label: String
    @Binding var value: String
    var height: CGFloat = 200.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            
            TextEditor(text: $value)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.top, 10)
                        
        }
    }
}
