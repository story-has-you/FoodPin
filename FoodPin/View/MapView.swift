//
//  MapView.swift
//  FoodPin
//
//  Created by 方曦 on 2023/7/29.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    var location: String = ""
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773),
                                                                       span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    @State private var annotatedItem: AnnotatedItem = AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773))
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [], annotationItems: [annotatedItem]) { item in
            // 添加标记
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        // ios15添加的修饰器，用于在装载视图之后的一些操作
        .task {
            convertAddress(location: location)
        }
    }
    
    private func convertAddress(location: String) {
            
            // Get location
        let geoCoder = CLGeocoder()

        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks,
                  let location = placemarks[0].location else {
                return
            }
            
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
            self.annotatedItem = AnnotatedItem(coordinate: location.coordinate)
        })
    }
}

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(location: "中国江苏省南京市江宁区天印大道1299号康桥公寓6栋208室")
    }
}
